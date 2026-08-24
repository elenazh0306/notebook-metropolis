import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tileDropdown", "editBtn", "saveBtn"]
  static values = { editing: { type: Boolean, default: false } }

  // Runs automatically whenever this.editingValue changes
  editingValueChanged() {
    this.updateMap()
  }

  // Automatically fires whenever a NEW tileDropdown is added to the DOM (including Turbo swaps)
  tileDropdownTargetConnected(target) {
    target.disabled = !this.editingValue
    target.classList.toggle("d-none", !this.editingValue)
  }

  edit() {
    this.editingValue = true
    this.updateMap()
  }

  save() {
    this.editingValue = false
    this.updateMap()
    // Optional: Trigger a toast notification or batch save request if needed
  }

  updateMap() {
    const isEditing = this.editingValue

    // Toggle button visibility
    if (this.hasEditBtnTarget) this.editBtnTarget.classList.toggle("d-none", isEditing)
    if (this.hasSaveBtnTarget) this.saveBtnTarget.classList.toggle("d-none", !isEditing)


    // Enable/disable all tile dropdowns across the grid
    this.tileDropdownTargets.forEach(select => {
      select.disabled = !isEditing
      select.classList.toggle("d-none", !isEditing)
    })
  }
}
