import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="table-row"
export default class extends Controller {
  static targets = ["deleteButton"];
  connect() {
    console.log("table controller connected");
    this.selectedRecords = 0;
  }

  selectRecord(e) {
    console.log("selectRecord", e);
    if (e.target.closest("input, label, a, button")) return;

    e.preventDefault();
    const checkbox = e.target.closest("tr").querySelector("input[type='checkbox']");

    if (checkbox) {
      this.updateDeleteButton(checkbox.checked);
      checkbox.checked = !checkbox.checked;
    }
  }

  updateDeleteButton(checked) {
    if (checked) {
      this.selectedRecords--;
    } else {
      this.selectedRecords++;
    }
    if (this.selectedRecords > 0) {
      this.deleteButtonTarget.parentElement.classList.remove("hidden");
    } else {
      this.deleteButtonTarget.parentElement.classList.add("hidden");
    }
    this.deleteButtonTarget.innerHTML = `Delete records (${this.selectedRecords})`;
  }

  resetDeleteButton() {
    this.selectedRecords = 0;
    this.deleteButtonTarget.parentElement.classList.add("hidden");
  }
}
