import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  closeOnSuccess(event) {
    if (event.detail.success) {
      const offcanvasElement = document.getElementById("category_new_form")
      const offcanvas = bootstrap.Offcanvas.getInstance(offcanvasElement)
      if (offcanvas) {
        offcanvas.hide()
      }
    }
  }
}
