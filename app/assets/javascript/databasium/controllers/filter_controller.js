import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["selectColumn", "form", "closeButton", "removeIcon"]
  static values = { columns: Array }


  connect() {
    console.log("connected to filter controller");
    this.previousValues = new WeakMap();
    this.addFilter();
    this.textOperators = ["eq", "not_eq", "matches", "does_not_match"];
    this.numberOperators = ["eq", "not_eq", "gt", "lt", "gteq", "lteq", "between"];
    this.dateOperators = ["eq", "not_eq", "gt", "lt", "gteq", "lteq", "between"];
    this.booleanOperators = ["eq", "not_eq", "is_true", "is_false", "is_null", "is_not_null"];
    this.selectOperatorsLables = {
      "eq": "=",
      "not_eq": "!=",
      "matches": "like",
      "does_not_match": "not like",
      "gt": ">",
      "lt": "<",
      "gteq": ">=",
      "lteq": "<=",
      "between": "between",
      "is_true": "= true",
      "is_false": "= false",
      "is_null": "is null",
      "is_not_null": "is not null",
    }
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
    const xIcon = this.removeIconTarget.cloneNode(true)
    xIcon.classList.remove("hidden")
    button.appendChild(xIcon)

    containerDiv.appendChild(button);
    containerDiv.appendChild(select);
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
    
    selectOperator.add(new Option("Select operator", ""));

    switch (selectedAttribute.type) {
      case "text": case "string":
        this.textOperators.forEach(operator => {
          selectOperator.add(new Option(this.selectOperatorsLables[operator], operator));
        });
        break;
      case "integer": case "float": case "decimal":
        this.numberOperators.forEach(operator => {
          selectOperator.add(new Option(this.selectOperatorsLables[operator], operator));
        });
        break;
      case "datetime" || "date" || "time":
        this.dateOperators.forEach(operator => {
          selectOperator.add(new Option(this.selectOperatorsLables[operator], operator));
        });
        break;
      case "boolean":
        this.booleanOperators.forEach(operator => {
          selectOperator.add(new Option(this.selectOperatorsLables[operator], operator));
        });
        break;
    }
    return selectOperator
  }

  removeFilter(event){
    const value = event.currentTarget.parentElement.querySelector("select")?.value
    if (value){
      this.columnsValue = this.columnsValue.map(c => {
        if (c.name === value) {
          return { ...c, used: false };
        } else {
          return c;
        }
      });
    }
    if (event.currentTarget.parentElement) {
      event.currentTarget.parentElement.remove()
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
