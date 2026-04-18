import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="table-row"
export default class extends Controller {
  static targets = ["checkbox"];
  connect() {
    console.log("table_row controller connected");
  }

  selectRecord(e) {
    if (!this.hasCheckboxTarget) return;
    if (e.target.closest("input, label, a, button")) return;

    e.preventDefault();
    this.checkboxTarget.checked = !this.checkboxTarget.checked;
  }
}
