import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="table-select"
export default class extends Controller {
  static targets = ["foreignKeyInput", "table", "selectedRecord"];

  connect() {}

  toggleVisibility() {
    this.tableTarget.remove();
  }

  selectRecord(e) {
    e.preventDefault();
    const record = e.currentTarget;
    this.foreignKeyInputTarget.value = record.dataset.recordId;
    this.selectedRecordTarget.textContent = record.dataset.recordId;
  }
}
