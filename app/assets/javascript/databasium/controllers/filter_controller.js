import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["selectColumn", "form", "closeButton"]
  static values = { columns: Array }


  connect() {
    console.log("connected to filter controller");
    this.previousValues = new WeakMap();
    this.addFilter();
  }

  update(event) {
    
  }

  chooseColumn(event){
    console.log(event)
    const selected = event.target.value
    let selectedAttribute = null;
    const next = this.columnsValue.map(c => {
      if (c.name === selected) {
        selectedAttribute = c;
        return { ...c, used: true };
      } else if (c.name === this.previousValues.get(event.target)) {
        return { ...c, used: false };
      } else {
        return c;
      }
    });
    if (!selectedAttribute) {
      return;
    }
    this.columnsValue = next
    const fieldAssigned = event.target.nextElementSibling
    if (fieldAssigned && fieldAssigned.tagName !== "BUTTON") {
      fieldAssigned.remove()
    }
    
    event.target.after( this.createInputField(selectedAttribute) )
  }

  rememberValue(event){
    this.previousValues.set(event.target, event.target.value)
    console.log(this.previousValues)
  }

  addFilter(){
    const containerDiv = document.createElement("div")
    containerDiv.classList = "flex gap-2"

    const select = document.createElement("select")
    const placeholder = new Option("Select column", "");
    select.add(placeholder);

    this.columnsValue.forEach(element => {
      if (!element.used) {
        select.add(new Option(element.name, element.name));
      }
    });
    select.setAttribute("data-form-target", "selectColumn");
    select.setAttribute("data-action", "change->filter#chooseColumn mousedown->filter#rememberValue");
    select.classList = "px-4 py-2 rounded-md border-2 border-gray-300"
    
    const button = document.createElement("button")
    
    button.setAttribute("data-action", "click->filter#removeFilter");
    button.classList = "text-red-500 hover:text-red-800"
    button.innerHTML = "remove filter"

    containerDiv.appendChild(select);
    containerDiv.appendChild(button);
    this.formTarget.lastElementChild.before(containerDiv)

  }

  createInputField(selectedAttribute) {
    const inputField = document.createElement("input")
    const typeMap = {
      string: "text",
      integer: "number",
      datetime: "date"
    }
  
    inputField.type = typeMap[selectedAttribute.type] || "text"
    inputField.classList = "border-2 border-gray-300"
    inputField.name =  "filter[" + selectedAttribute.name + "]"
    return inputField
  }

  removeFilter(event){
    console.log("Adada")
    if (event.target.parentElement) {
      event.target.parentElement.remove()
    }
  }
}
