import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-migration"
export default class extends Controller {
  static targets = ["column"]

  connect() {
    console.log("connected to new migration controller");
  }

  addColumn(e) {
    console.log("adding column");
    const column = this.columnTarget.cloneNode(true)
    column.classList.remove("hidden")
    e.currentTarget.before(column)
  }

  removeColumn(e) {
    if (this.columnTargets.length <= 1) {
      alert("You need at least one column");
      return;
    }
    e.currentTarget.parentElement.remove();
  }
}
