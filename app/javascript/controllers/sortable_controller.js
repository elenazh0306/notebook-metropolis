import { Controller } from "@hotwired/stimulus"
import Sortable, { Swap } from "sortablejs"

// Connects to data-controller="sortable"
export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      swap: true, // Enable swap plugin
	    swapClass: 'highlight', // The class applied to the hovered swap item
	    animation: 150// Optional styling class for the item being dragged
      onEnd: this.end.bind(this)
    })
  }

  end(event) {
    // This function triggers after an item is dropped.
    // Use event.oldIndex and event.newIndex to track changes.
    console.log(`Moved item from index ${event.oldIndex} to ${event.newIndex}`)

    // Optional: Send an AJAX patch request here to update the DB position
  }
}
