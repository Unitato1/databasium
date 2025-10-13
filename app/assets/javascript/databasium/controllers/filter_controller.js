import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["selectColumn", "form"]
  static values = { columns: Array }


  connect() {
    console.log("connected to filter controller")

    // this.debounceTimer = null
    // this.lastSubmittedValue = null
  }

  update(event) {
    
  }

  chooseColumn(event){
    const selected = event.target.value
    const next = this.columnsValue.map(c =>
      c.name === selected ? { ...c, used: true } : c
    )
    console.log(next)
    const selectedAttribute = this.columnsValue.find(c => c.name === selected)
    this.columnsValue = next
    const fieldAssigned = event.target.nextElementSibling
    if (fieldAssigned) {
      fieldAssigned.remove()
    }
    
    event.target.after( this.createInputField(selectedAttribute) )
  }

  addFilter(){
    const template = this.selectColumnTarget
    const clone = template.cloneNode(true)
    const containerDiv = document.createElement("div")
    containerDiv.classList = "flex"
    clone.value = ""

    containerDiv.appendChild(clone)
    this.formTarget.appendChild(containerDiv, this.formTarget.lastElementChild)        
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
  
    return inputField
  }
}
