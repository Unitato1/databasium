import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-migration"
export default class extends Controller {
  static targets = ["column", "table_name_from", "table_name_to", "table_name"]

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

  set_action(e) {
    if (e.currentTarget.value === "create") {
      this.table_name_fromTarget.classList.add("hidden");
      this.table_name_toTarget.classList.add("hidden");
      this.table_nameTarget.classList.remove("hidden");
    } else if (e.currentTarget.value === "remove") {
      this.table_name_fromTarget.classList.remove("hidden");
      this.table_name_toTarget.classList.add("hidden");
      this.table_nameTarget.classList.add("hidden");
    } else if (e.currentTarget.value === "add") {
      this.table_name_fromTarget.classList.add("hidden");
      this.table_name_toTarget.classList.remove("hidden");
      this.table_nameTarget.classList.add("hidden");
    }
  }
}
