import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="flash"
export default class extends Controller {
  static targets = [];

  connect() {}

  close() {
    // setTimeout(() => {
    this.element.classList.add("opacity-0");
    // }, 1000);
  }
}
