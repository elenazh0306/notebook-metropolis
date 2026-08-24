import { Controller } from "@hotwired/stimulus"
import Muuri from "muuri"

export default class extends Controller {
  static values = {
    tileSize: { type: Number, default: 100 },
    rows: { type: Number, default: 4 },
    cols: { type: Number, default: 4 }
  }

  connect() {
    this.initBoardSize()
    this.initMuuri()
  }

  // 1. Explicitly set dimensions on the board container
  // Prevents offsetWidth / offsetHeight collapsing due to absolute children
  initBoardSize() {
    const width = this.colsValue * this.tileSizeValue
    const height = this.rowsValue * this.tileSizeValue
    this.element.style.width = `${width}px`
    this.element.style.height = `${height}px`
  }

  initMuuri() {
    this.board = new Muuri(this.element, {
      dragEnabled: true,
      dragSort: false,
      layoutOnResize: false,
      dragHandle: ".drag-handle, .tile-surface", // Let clicks on buttons pass through
      dragStartPredicate: {
        distance: 5,
        delay: 0,
        handle: (item, event) => {
          // Prevent drag when interacting with dropdowns or action buttons
          const target = event.target
          return !target.closest("select, button, a, form, input")
        }
      },
      layout: (items) => this.calculateMatrixLayout(items)
    })

    this.board.on("dragStart", (item) => {
      this.draggedItem = item
      const el = item.getElement()
      this.dragStartX = parseInt(el.dataset.tileXValue, 10)
      this.dragStartY = parseInt(el.dataset.tileYValue, 10)
      el.classList.add("is-dragging")
    })

    this.board.on("dragMove", (item, event) => {
      this.updateDropHighlight(event)
    })

    this.board.on("dragEnd", (item, event) => {
      const el = item.getElement()
      el.classList.remove("is-dragging")
      this.clearDropHighlights()

      // Handle the swap using client hit testing
      this.handleSwap(item, event)
      this.draggedItem = null
    })

    this.board.refreshItems().layout()
  }

  calculateMatrixLayout(items) {
    const tileSize = this.tileSizeValue
    const slots = items.map((item) => {
      const el = item.getElement()
      const x = parseInt(el.dataset.tileXValue, 10) || 0
      const y = parseInt(el.dataset.tileYValue, 10) || 0
      return {
        left: x * tileSize,
        top: y * tileSize
      }
    })

    return {
      slots,
      styles: {
        width: this.colsValue * tileSize,
        height: this.rowsValue * tileSize
      }
    }
  }

  // 2. Browser hit-testing to find destination tile
  // Native elementFromPoint / elementsFromPoint respects 3D CSS transforms!
  getTargetTileElement(event) {
    if (!event) return null
    const clientX = event.clientX || (event.touches && event.touches[0]?.clientX)
    const clientY = event.clientY || (event.touches && event.touches[0]?.clientY)
    if (!clientX || !clientY) return null

    const elements = document.elementsFromPoint(clientX, clientY)
    const draggedEl = this.draggedItem?.getElement()

    for (const el of elements) {
      const tileEl = el.closest(".muuri-item")
      if (tileEl && tileEl !== draggedEl && this.element.contains(tileEl)) {
        return tileEl
      }
    }
    return null
  }

  updateDropHighlight(event) {
    this.clearDropHighlights()
    const targetTile = this.getTargetTileElement(event)
    if (targetTile) {
      targetTile.classList.add("drop-target")
    }
  }

  clearDropHighlights() {
    this.element.querySelectorAll(".drop-target").forEach((el) => {
      el.classList.remove("drop-target")
    })
  }

  handleSwap(draggedItem, event) {
    const draggedEl = draggedItem.getElement()
    const targetEl = this.getTargetTileElement(event)

    if (!targetEl) {
      this.snapBack()
      return
    }

    const startX = this.dragStartX
    const startY = this.dragStartY
    const targetX = parseInt(targetEl.dataset.tileXValue, 10)
    const targetY = parseInt(targetEl.dataset.tileYValue, 10)

    if (targetX === startX && targetY === startY) {
      this.snapBack()
      return
    }

    // Swap datasets
    draggedEl.dataset.tileXValue = targetX
    draggedEl.dataset.tileYValue = targetY
    targetEl.dataset.tileXValue = startX
    targetEl.dataset.tileYValue = startY

    // Swap IDs
    draggedEl.id = `tile_${targetX}_${targetY}`
    targetEl.id = `tile_${startX}_${startY}`

    // Recalculate Muuri layout
    this.board.refreshItems()
    this.board.layout(true)

    // Persist swap to backend Rails route
    this.persistSwap({
      x: startX,
      y: startY,
      targetX: targetX,
      targetY: targetY
    })
  }

  snapBack() {
    this.board.refreshItems()
    this.board.layout(true)
  }

  persistSwap(swapData) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

    fetch("/tile_maps/swap", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
        "Accept": "application/json"
      },
      body: JSON.stringify(swapData)
    })
      .then((response) => {
        if (!response.ok) throw new Error("Failed to persist tile swap")
        return response.json()
      })
      .catch((error) => {
        console.error("Tile swap failed:", error)
      })
  }

  disconnect() {
    if (this.board) {
      this.board.destroy()
      this.board = null
    }
  }
}
