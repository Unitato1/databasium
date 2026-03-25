import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  static targets = [];

  connect() {
    this.debounceTimer = null;
    this.lastSubmittedValue = null;
  }

  update(event) {
    const currentValue = event.target.value;
    clearTimeout(this.debounceTimer);
    this.debounceTimer = setTimeout(() => {
      if (this.lastSubmittedValue === currentValue) return;

      this.lastSubmittedValue = currentValue;

      if (event.target.form) event.target.form.requestSubmit();
    }, 100);
  }
}
