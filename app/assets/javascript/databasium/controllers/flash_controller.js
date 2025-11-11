import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static targets = []

  connect() {
    console.log("connected to flash controller");
    setTimeout(() => {
        this.element.classList.add("opacity-0")
        setTimeout(() => this.element.remove(), 1000)
    }, 4000)
  }

  close(){
    console.log("closing flash");
    this.element.classList.add("opacity-0")
    setTimeout(() => this.element.remove(), 1000)
  }
}
