import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="table-select"
export default class extends Controller {
  static targets = ["foreignKeyInput", "table"]

  connect() {
    console.log("table_select controller connected");
  }

  toggleVisibility(){
    // this.element.classList.add("hidden")
    this.tableTarget.remove()
    console.log("table removed")
  }

  selectRecord(e){
    e.preventDefault();
    const record = e.currentTarget;
    this.foreignKeyInputTarget.value = record.dataset.recordId;    
  }
}
