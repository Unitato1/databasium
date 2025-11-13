import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="collapse"
export default class extends Controller {
  static targets = ["content", "collapseIcon"]

  connect() {
  }

  toggle(e){
    if (this.hasContentTarget) {
        this.contentTargets.forEach(target => {
            target.classList.toggle("hidden")
        })
    }
    this.collapseIconTarget.classList.toggle("rotate-180")
  }
}
