import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = {
    x: Number,
    y: Number,
    current: String,
    types: Array
  }

  cycleForward(event) {
    event.preventDefault()
    this.rotate(1)
  }

  rotate(step) {
    const currentIndex = this.typesValue.indexOf(this.currentValue)
    const nextIndex = (currentIndex + step) % this.typesValue.length
    const nextType = this.typesValue[nextIndex]

    const formData = new FormData()
    formData.append("x", this.xValue)
    formData.append("y", this.yValue)
    formData.append("new_type", nextType)

    fetch("/tile_map/update", {
      method: "PATCH",
      headers: {
        // X-CSRF-Token: Fetches Rails' security token from the HTML <head> tag so Rails accepts the request without throwing an InvalidAuthenticityToken error.
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        // Explicitly asks Rails to respond with a Turbo Stream snippet instead of a full HTML page.
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: formData
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
  }
}
