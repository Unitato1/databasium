import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="relation"
export default class extends Controller {
  connect() {
    console.log("relation controller connected");
  }
  removeRelation(e) {
    e.currentTarget.parentElement.remove();
  }
}
