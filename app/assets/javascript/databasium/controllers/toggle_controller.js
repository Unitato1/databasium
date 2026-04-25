import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="toggle"
export default class extends Controller {
  connect() {
    this.openEl = null;
    // this.lastOpenElSticky = null;
  }

  toggle(e) {
    const el = document.getElementById(e.currentTarget.dataset.toggle);
    if (!el) return;
    const isOpen = !el.classList.contains("hidden");

    if (this.openEl && this.openEl !== el) {
      this.openEl.classList.add("hidden");
    }

    el.classList.toggle("hidden", isOpen);
    this.openEl = isOpen ? (this.openEl === el ? null : this.openEl) : el;
  }

  toggleSticky(e) {
    const el = document.getElementById(e.currentTarget.dataset.toggle);
    if (!el) return;
    const isOpen = !el.classList.contains("hidden");
    el.classList.toggle("hidden", isOpen);
  }
}
