import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="attribute"
export default class extends Controller {
  static targets = ["name", "nameInput", "nameValidationInput"];

  connect() {}

  updateName() {
    const name = this.nameInputTarget.value;
    this.nameTarget.textContent = name;
    this.nameValidationInputTargets.forEach((target) => {
      target.value = name;
    });
  }

  updateValidationName(e) {
    const name = this.nameInputTarget.value;
    this.nameValidationInputTargets.forEach((target) => {
      target.value = name;
    });
  }

  remove() {
    this.element.remove();
  }
}
