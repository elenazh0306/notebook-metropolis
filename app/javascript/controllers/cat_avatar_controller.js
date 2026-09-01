import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["video", "avatarColumn"]
  static values = {
    idleSrc: String,
    talkingSrc: String
  }

  connect() {
    // Listen for Turbo Stream / ActionCable rendering events on the chat box
    document.addEventListener("turbo:before-stream-render", this.startTalking.bind(this))
    document.addEventListener("turbo:render", this.stopTalking.bind(this))
  }

  disconnect() {
    document.removeEventListener("turbo:before-stream-render", this.startTalking.bind(this))
    document.removeEventListener("turbo:render", this.stopTalking.bind(this))
  }

  // Switch to talking loop and speed up border pulse when AI response streams
  startTalking() {
    if (this.videoTarget.src.includes(this.talkingSrcValue)) return

    this.videoTarget.src = this.talkingSrcValue
    this.videoTarget.play()

    if (this.hasAvatarColumnTarget) {
      this.avatarColumnTarget.classList.add("is-speaking")
    }

    // Safety fallback: Automatically return to idle after 6 seconds if stream ends quietly
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.stopTalking(), 6000)
  }

  // Return to idle loop and restore slow breathing pulse when message completes
  stopTalking() {
    if (this.videoTarget.src.includes(this.idleSrcValue)) return

    this.videoTarget.src = this.idleSrcValue
    this.videoTarget.play()

    if (this.hasAvatarColumnTarget) {
      this.avatarColumnTarget.classList.remove("is-speaking")
    }
  }
}
