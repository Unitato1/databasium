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
    
    this.columnsValue = this.columnsValue.map(c => {
      if (c.name === selected) {
        selectedAttribute = c;
        return { ...c, used: true };
      } else if (c.name === this.previousValues.get(event.target)) {
        return { ...c, used: false };
      } else {
        return c;
      }
    });

    this.resetOptions();
    
    if (!selectedAttribute) {
      return;
    }
    let fieldAssigned = event.target.nextElementSibling
    if (fieldAssigned && fieldAssigned.tagName !== "BUTTON") {
      fieldAssigned.remove()
    }

    fieldAssigned = event.target.nextElementSibling
    if (fieldAssigned && fieldAssigned.tagName !== "BUTTON") {
      fieldAssigned.remove()
    }

    event.target.after( this.createInputField(selectedAttribute) )
    event.target.after( this.createOperatorField(selectedAttribute) )
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
    select.setAttribute("data-filter-target", "selectColumn");
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
    inputField.name =  "filter[" + selectedAttribute.name + "][value]"
    return inputField
  }

  createOperatorField(selectedAttribute) {
    const selectOperator = document.createElement("select")
    selectOperator.name = "filter[" + selectedAttribute.name + "][operator]"
    selectOperator.classList = "border-2 border-gray-300"
    const operatorPlaceholder = new Option("Select operator", "");
    selectOperator.add(operatorPlaceholder);
    selectOperator.add(new Option("Equals", "eq"));
    selectOperator.add(new Option("Not equals", "not_eq"));
    selectOperator.add(new Option("Like", "matches"));
    selectOperator.add(new Option("Not like", "does_not_match"));
    selectOperator.add(new Option("Greater than", "gt"));
    selectOperator.add(new Option("Less than", "lt"));
    selectOperator.add(new Option("Greater than or equal to", "gteq"));
    selectOperator.add(new Option("Less than or equal to", "lteq"));
    selectOperator.add(new Option("In", "in"));
    selectOperator.add(new Option("Not in", "not_in"));
    selectOperator.add(new Option("Is null", "is_null"));
    selectOperator.add(new Option("Is not null", "is_not_null"));
    return selectOperator
  }

  removeFilter(event){
    const value = event.target.parentElement.querySelector("select")?.value
    console.log(value)
    if (value){
      this.columnsValue = this.columnsValue.map(c => {
        if (c.name === value) {
          return { ...c, used: false };
        } else {
          return c;
        }
      });
    }
    if (event.target.parentElement) {
      event.target.parentElement.remove()
    }
    this.resetOptions();
  }

  resetOptions(){
    this.selectColumnTargets.forEach((select, index) => {
      const value = select.value

      select.innerHTML = "";

      select.add(new Option("Select column", ""));

      this.columnsValue
      .forEach(col => {
        if (!col.used || col.name === value){
          select.add(new Option(col.name, col.name));
        }
      });
      select.value = value;
    });
  }
}
