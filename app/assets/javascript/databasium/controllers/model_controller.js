import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hide"
export default class extends Controller {
  static targets = ["attribute", "validation", "container"]

  connect() {
  }

  addValidation(e) {
    console.log(this.validationTarget)
    
    // 1. Grab the HTML inside the <template>
    const content = this.validationTarget.innerHTML
    
    // 2. Insert it into the container
    this.containerTarget.insertAdjacentHTML('beforeend', content)
  }
}
