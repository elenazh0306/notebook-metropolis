import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => {
      this.element.classList.add("fade-out")

      setTimeout(() => {
        this.element.remove()
      }, 300);
    }, 3000);
  }
  disconnect() {
    clearTimeout(this.timeout)
  }
}
