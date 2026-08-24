import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.modal = this.element.closest(".modal")

    if (this.modal) {
      this.modal.addEventListener("shown.bs.modal", this.handleModalOpen)
    }
    this.observer = new MutationObserver(() => {
      this.scrollToBottom()
    })
    this.observer.observe(this.element, {
      childList: true,
      subtree: true,
    })
  }
  disconnect() {
    this.observer?.disconnect()

    if (this.modal) {
      this.modal.removeEventListener("shown.bs.modal", this.handleModalOpen)
    }
  }
  handleModalOpen = () => {
    this.prepareChat()
  }

  prepareChat() {
    requestAnimationFrame(() => {
      this.scrollToBottom()
      this.element.style.visibility = "visible"
    })
  }
  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight
  }
}
