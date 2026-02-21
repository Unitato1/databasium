import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="attribute"
export default class extends Controller {
  static targets = ["name", "nameValidationInput"]

  connect() {
  }

  updateName(e){
    const name = e.target.value
    this.nameTarget.textContent = name
    this.nameValidationInputTargets.forEach(target => {
      target.value = name
    })
  }
}
