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
    const capitalizedContainer = container[0].toUpperCase() + container.slice(1);

    const closestGroup =
      event.currentTarget.closest(`.${container}`) || event.currentTarget.closest(".group");
    if (
      this[`has${capitalizedTarget}Target`] &&
      (closestGroup || this[`has${capitalizedContainer}Target`])
    ) {
      const content = this[`${target}Target`].innerHTML;
      if (closestGroup) {
        closestGroup.insertAdjacentHTML("beforeend", content);
      } else {
        this[`${container}Target`].insertAdjacentHTML("beforeend", content);
      }
    } else {
      console.log(
        "You are missing a " +
          capitalizedTarget +
          " target and/or " +
          capitalizedContainer +
          " container target please define it in the js controller and then in html template"
      );
    }
  }
}
