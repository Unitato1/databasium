import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="new-migration"
export default class extends Controller {
  static targets = [
    "column",
    "table_name_from",
    "table_name_to",
    "table_name",
    "add_model_container",
    "add_model",
    "validation",
    "validations",
    "validation_column_name"
  ];

  connect() {
    this.addedColumns = [];
    this.columnsNames = [];
  }

  addColumn(e) {
    const column = this.columnTarget.cloneNode(true);
    this.addedColumns.push(column);
    column.classList.remove("hidden");
    e.currentTarget.before(column);
  }

  updateColumnNames() {
    this.columnsNames = this.addedColumns.map((column) => column.querySelector("input").value);

    const options = [new Option("Select a column", "")];

    this.columnsNames.forEach((name) => {
      options.push(new Option(name, name));
    });

    if (this.hasValidationTarget) {
      this.validation_column_nameTargets.forEach((target) => {
        const selected = target.options[target.selectedIndex].value;
        target.innerHTML = "";
        options.forEach((opt) => {
          const clone = opt.cloneNode(true);
          clone.selected = selected === opt.value;
          target.add(clone);
        });
      });
    }
  }

  removeColumn(e) {
    if (this.columnTargets.length <= 1) {
      alert("You need at least one column");
      return;
    }
    this.addedColumns = this.addedColumns.filter(
      (column) => column !== e.currentTarget.parentElement
    );
    e.currentTarget.parentElement.remove();
    this.updateColumnNames();
  }

  addValidation(e) {
    const validation = this.validationTarget.cloneNode(true);
    validation.classList.remove("hidden");
    e.currentTarget.before(validation);
  }

  getColumnNames() {
    this.columnsNames = this.addedColumns.map((column) => column.querySelector("input").value);
  }

  removeValidation(e) {
    e.currentTarget.parentElement.remove();
  }

  set_action(e) {
    if (e.currentTarget.value === "create") {
      this.table_name_fromTarget.classList.add("hidden");
      this.table_name_toTarget.classList.add("hidden");
      this.table_nameTarget.classList.remove("hidden");
      this.add_model_containerTarget.classList.remove("hidden");
      this.add_modelTarget.disabled = false;
      this.validationsTarget.classList.remove("hidden");
    } else if (e.currentTarget.value === "remove") {
      this.table_name_fromTarget.classList.remove("hidden");
      this.table_name_toTarget.classList.add("hidden");
      this.table_nameTarget.classList.add("hidden");
      this.add_model_containerTarget.classList.add("hidden");
      this.add_modelTarget.disabled = true;
      this.validationsTarget.classList.add("hidden");
    } else if (e.currentTarget.value === "add") {
      this.table_name_fromTarget.classList.add("hidden");
      this.table_name_toTarget.classList.remove("hidden");
      this.table_nameTarget.classList.add("hidden");
      this.add_model_containerTarget.classList.add("hidden");
      this.add_modelTarget.disabled = true;
      this.validationsTarget.classList.add("hidden");
    }
  }
}
