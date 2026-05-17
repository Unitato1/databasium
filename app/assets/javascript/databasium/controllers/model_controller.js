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

    if (!target || !container) return;

    const capitalizedTarget = target[0].toUpperCase() + target.slice(1);

    if (!this[`has${capitalizedTarget}Target`]) return;

    const scope = event.currentTarget.closest("[data-controller~='attribute']") || this.element;
    const destination = scope.querySelector(`[data-model-target='${container}']`);
    if (!destination) return;

    destination.insertAdjacentHTML("beforeend", this[`${target}Target`].innerHTML);
  }
}
