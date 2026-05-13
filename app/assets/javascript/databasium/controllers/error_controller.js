import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="error"
export default class extends Controller {
  static targets = [];

  connect() {}

  close() {
    this.element.classList.add("opacity-0");
    setTimeout(() => {
      this.element.classList.add("hidden");
    }, 1000);
  }
}
