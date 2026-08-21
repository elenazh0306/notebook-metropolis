import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trash", "empty"]
  static values = {
    x: Number,
    y: Number
  }

  connect() {
    this.updateMap()
  }

  drag(event) {
    const tileElement = event.target.closest('[data-category-id]')

    if (tileElement) {
      event.target.classList.add('dragging')

      // storing picked up coordinates
      this.draggedElement = tileElement
      this.coordX = tileElement.dataset.categoryX
      this.coordY = tileElement.dataset.categoryY
      this.categoryId = tileElement.dataset.categoryId
    }

  }

  drop(event) {
    event.preventDefault()


    const targetTile = event.currentTarget.closest('[data-tile-x-value]')
    if (targetTile && this.draggedElement) {

      // collecting new coord
      const newX = targetTile.dataset.tileXValue
      const newY = targetTile.dataset.tileYValue

      // updating DOM
      this.draggedElement.dataset.categoryX = newX
      this.draggedElement.dataset.categoryY = newY

      // save changes at backend
      // this.updateBackend(this.categoryId, newX, newY)

      // clean up reference
      this.draggedElement.classList.remove('dragging')
      this.draggedElement = null
    }


  }

  over(event) {
    event.preventDefault()
  }

  // updateBackend(categoryId, x, y) {

  //   fetch(`/categories/${categoryId}`, {
  //     method: "PATCH",
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //       "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
  //     },
  //     body: JSON.stringify({ category: { x: x, y: y } })
  //   })
  // }


}
