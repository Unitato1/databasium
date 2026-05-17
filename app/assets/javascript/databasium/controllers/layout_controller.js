import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="layout"
export default class extends Controller {
  static targets = ["sidebar"];

  connect() {}

  toggleSidebar(event) {
    event.preventDefault();
    this.sidebarTarget.classList.toggle("hidden");
  }
}
