import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { x: Number, y: Number, url: String }

  dragStart(event) {
    // Store source tile coordinates in dataTransfer
    event.dataTransfer.setData("text/plain", JSON.stringify({
      x: this.xValue,
      y: this.yValue
    }))
    event.dataTransfer.effectAllowed = "move"
    this.element.classList.add("dragging")
  }

  dragOver(event) {
    event.preventDefault() // Required to allow drop
    event.dataTransfer.dropEffect = "move"
    this.element.classList.add("drag-over")
  }

  dragLeave() {
    this.element.classList.remove("drag-over")
  }

  drop(event) {
    event.preventDefault()
    this.element.classList.remove("drag-over")

    const sourceData = JSON.parse(event.dataTransfer.getData("text/plain"))
    const targetData = { x: this.xValue, y: this.yValue }

    // Avoid swapping a tile with itself
    if (sourceData.x === targetData.x && sourceData.y === targetData.y) return

    // Trigger update request via Fetch API
    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: JSON.stringify({
        source: sourceData,
        target: targetData
      })
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
  }

}
