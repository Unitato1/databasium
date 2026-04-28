import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="model"
export default class extends Controller {
  static targets = [
    "attribute",
    "validation",
    "relation",
    "attributesContainer",
    "validationsContainer",
    "relationsContainer"
  ];

  connect() {}

  add(event) {
    const target = event.params["target"];
    const container = event.params["container"];

    if (!target || !container) {
      console.warn("Missing model controller action params", { target, container });
      return;
    }

    const capitalizedTarget = target[0].toUpperCase() + target.slice(1);

    if (!this[`has${capitalizedTarget}Target`]) {
      console.log(
        `Missing ${capitalizedTarget} target — define it in the js controller and html template`
      );
      return;
    }

    const scope = event.currentTarget.closest("[data-controller~='attribute']") || this.element;
    const destination = scope.querySelector(`[data-model-target='${container}']`);

    if (!destination) {
      console.log(`No ${container} found in the current scope`);
      return;
    }

    destination.insertAdjacentHTML("beforeend", this[`${target}Target`].innerHTML);
  }
}
