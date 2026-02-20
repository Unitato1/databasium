import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static targets = []

  connect() {
    setTimeout(() => {
        this.element.classList.add("opacity-0")
        setTimeout(() => this.element.remove(), 1000)
    }, 4000)
  }

  close(){
    this.element.classList.add("opacity-0")
    setTimeout(() => this.element.remove(), 1000)
  }
}
