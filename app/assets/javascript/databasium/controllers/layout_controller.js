import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="layout"
export default class extends Controller {
  static targets = ["sidebar", "headerActions"];

  connect() {
    console.log("layout controller connected");
  }

  toggleSidebar(event) {
    event.preventDefault();
    this.sidebarTarget.classList.toggle("hidden");
    console.log(this.sidebarTarget.classList);
  }
}
