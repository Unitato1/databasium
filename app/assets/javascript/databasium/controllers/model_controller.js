import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hide"
export default class extends Controller {
  static targets = ["attribute", "validation", "attributesContainer", "validationsContainer"]

  connect() {
  }

  add(event) {
    const target = event.params["target"]
    const container = event.params["container"]

    const capitalizedTarget = target[0].toUpperCase() + target.slice(1)
    const capitalizedContainer = container[0].toUpperCase() + container.slice(1)
    const closestGroup = event.currentTarget.closest(".group") 
    if (this[`has${capitalizedTarget}Target`] && (closestGroup || this[`has${capitalizedContainer}Target`])) {
      const content = this[`${target}Target`].innerHTML
      if (closestGroup) {
        closestGroup.insertAdjacentHTML('beforeend', content)
      } else {
        this[`${container}Target`].insertAdjacentHTML('beforeend', content)
      }
    } else {
      console.log("You are missing a " + capitalizedTarget + " target and/or " + capitalizedContainer +  " container target please define it in the js controller and then in html template")
    }

    // 1. Grab the HTML inside the <template>
    // const target = event.params["target"] + "Target"
    // console.log(this.hasValidationTarget)
    // console.log(this["has" + "ValidationTarget"])
    // if (this["has" + target.toUpperCase()]) {
    //   console.log("Adb")
    //   console.log(this[target]().innerHTML)
    // }
    // console.log(event.params) 
    // console.log(event.params["target"]) 
    
    // 2. Insert it into the container
  }
}
