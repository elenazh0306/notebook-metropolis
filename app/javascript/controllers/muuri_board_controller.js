import { Controller } from "@hotwired/stimulus"
import Muuri from "muuri"

export default class extends Controller {
  connect() {
    this.grid = new Muuri(this.element, {
      dragEnabled: true,
      dragHandle: ".draggable",
      dragSortPredicate: {
        action: "swap",
        threshold: 50
      }
    })

    this.grid.on("dragEnd", (item) => {
      const element = item.getElement()
      const draggable = element.querySelector(".draggable")
      const categoryId = draggable?.dataset.categoryId
      if (!categoryId) return
      // Get target element under drop coordinates
      const tileContainer = element.closest("[data-tile-x-value]")
      if (!tileContainer) return

      const newX = tileContainer.dataset.tileXValue
      const newY = tileContainer.dataset.tileYValue

      this.updateBackend(categoryId, newX, newY)
    })
  }

  disconnect() {
    if (this.grid) {
      this.grid.destroy()
    }
  }

  updateBackend(categoryId, x, y) {
    fetch(`/categories/${categoryId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ category: { x: x, y: y } })
    })
  }
}
