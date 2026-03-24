import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="hide"
export default class extends Controller {
  connect() {
    this.lastShown = null;
  }

  hide(e) {
    const id = e.currentTarget.dataset.hide;
    const element = document.getElementById(id);
    if (this.lastShown) {
      this.lastShown.classList.toggle("hidden");
    }
    if (element) {
      this.lastShown = element;
      element.classList.toggle("hidden");
    }
  }
}
