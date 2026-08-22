import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="room"
export default class extends Controller {
  // Define targets so Stimulus can find the exact elements inside THIS modal
  static targets = ["video", "interactiveLayer"]

  // Reset the video, so it runs every time the room modal opens
  connect() {
    this.modalElement = this.element.closest('.modal')

    if (this.modalElement) {
      // Listen for WHEN THE MODAL FINISHES CLOSING
      this.handleModalClose = this.resetRoom.bind(this)
      this.modalElement.addEventListener('hidden.bs.modal', this.handleModalClose)

      // Listen for WHEN THE MODAL OPENS
      this.handleModalOpen = this.playVideo.bind(this)
      this.modalElement.addEventListener('shown.bs.modal', this.handleModalOpen)
    }

    this.resetRoom()
  }

  disconnect() {
    if (this.modalElement) {
      this.modalElement.removeEventListener('hidden.bs.modal', this.handleModalClose)
      this.modalElement.removeEventListener('shown.bs.modal', this.handleModalOpen)
    }
  }

  // Resets everything silently WHILE THE MODAL IS CLOSED
  resetRoom() {
    if (this.hasVideoTarget && this.hasInteractiveLayerTarget) {
      // Temporarily disable transitions during invisible reset so there's zero flash
      this.videoTarget.style.transition = 'none'
      this.interactiveLayerTarget.style.transition = 'none'

      this.videoTarget.currentTime = 0
      this.interactiveLayerTarget.classList.remove('room-active')
      this.interactiveLayerTarget.classList.add('room-hidden')

      // Re-enable SCSS transitions after reset
      setTimeout(() => {
        if (this.hasVideoTarget && this.hasInteractiveLayerTarget) {
          this.videoTarget.style.transition = ''
          this.interactiveLayerTarget.style.transition = ''
        }
      }, 50)
    }
  }

  // Plays the pre-reset video the instant the modal pops open!
  playVideo() {
    // DEV MODE: Remove comments around these two lines to force
    // the static room and hotspots to show immediately!
    // this.interactiveLayerTarget.classList.remove('room-hidden')
    // this.interactiveLayerTarget.classList.add('room-active')

    if (this.hasVideoTarget) {
      this.videoTarget.play().catch(() => {})
    }
  }

  // transition method that initiates when the video ends
  transition() {
    if (this.hasVideoTarget && this.hasInteractiveLayerTarget) {
      // Fade in the static image + clickable hotspots
      this.interactiveLayerTarget.classList.remove('room-hidden')
      this.interactiveLayerTarget.classList.add('room-active')
    }
  }
}
