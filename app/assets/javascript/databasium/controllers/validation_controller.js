import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="validation"
export default class extends Controller {
  static targets = ["valueInput", "acceptanceOptions", "numberOptions", "stringOptions"];

  connect() {
    console.log("validation controller connected");
    this.lastValueInput = "acceptance";
  }

  updateType(event) {
    const selectedValue = event.target.value;
    this.valueInputTarget.setAttribute("list", `${selectedValue}-options`);
  }
}
