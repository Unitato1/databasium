import { Controller } from "@hotwired/stimulus";

const OPERATOR_LABELS = {
  eq: "=",
  not_eq: "!=",
  matches: "like",
  does_not_match: "not like",
  gt: ">",
  lt: "<",
  gteq: ">=",
  lteq: "<=",
  // between: "between",
  is_true: "= true",
  is_false: "= false",
  is_null: "is null",
  is_not_null: "is not null"
};

const TEXT_OPERATORS = ["eq", "not_eq", "matches", "does_not_match"];
const NUMBER_OPERATORS = ["eq", "not_eq", "gt", "lt", "gteq", "lteq"];
const DATE_OPERATORS = ["eq", "not_eq", "gt", "lt", "gteq", "lteq"];
const BOOLEAN_OPERATORS = ["eq", "not_eq", "is_true", "is_false", "is_null", "is_not_null"];

const INPUT_TYPE_BY_COLUMN = {
  string: "text",
  text: "text",
  integer: "number",
  float: "number",
  decimal: "number",
  datetime: "date",
  date: "date",
  time: "time"
};

const CL = {
  row: "flex items-center py-1 border-l-1 border-border ps-1 ms-1",
  select: "px-4 py-2 rounded-md border-1 border-border w-fit h-10 bg-panel",
  selectMuted: "px-4 py-2 rounded-md border-1 border-border w-fit h-10 bg-background",
  selectWhere: "px-4 py-2 rounded-md border-1 border-border w-fit h-10",
  input: "px-4 py-2 rounded-md border-1 border-border w-fit max-w-40 h-10",
  separator: "bg-panel inline-block h-2 w-3",
  removeBtn: "text-red-500 hover:text-red-800"
};

function operatorsForColumnType(type) {
  if (type === "text" || type === "string") return TEXT_OPERATORS;
  if (type === "integer" || type === "float" || type === "decimal") return NUMBER_OPERATORS;
  if (type === "datetime" || type === "date" || type === "time") return DATE_OPERATORS;
  if (type === "boolean") return BOOLEAN_OPERATORS;
  return TEXT_OPERATORS;
}

function fillOperatorOptions(select, operatorKeys) {
  select.add(new Option("Operator", ""));
  for (const key of operatorKeys) {
    select.add(new Option(OPERATOR_LABELS[key], key));
  }
}

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["selectColumn", "form", "closeButton", "removeIcon"];
  static values = { columns: Array };

  connect() {
    this.previousValues = new WeakMap();
    this.addFilter(null, false);
  }

  createSeparator() {
    const el = document.createElement("div");
    el.className = CL.separator;
    return el;
  }

  chooseColumn(event) {
    const columnSelect = event.target;
    const selected = columnSelect.value;
    let selectedAttribute = null;

    this.columnsValue = this.columnsValue.map((c) => {
      if (c.name === selected) {
        selectedAttribute = c;
        return { ...c, used: true };
      }
      if (c.name === this.previousValues.get(columnSelect)) {
        return { ...c, used: false };
      }
      return c;
    });

    this.resetOptions();

    if (this.previousValues.get(columnSelect)) {
      while (
        columnSelect.nextElementSibling &&
        columnSelect.nextElementSibling.tagName !== "BUTTON"
      ) {
        columnSelect.nextElementSibling.remove();
      }
    }

    if (!selectedAttribute) {
      return;
    }

    const sep = this.createSeparator();
    columnSelect.after(this.createInputField(selectedAttribute));
    columnSelect.after(sep.cloneNode(true));
    columnSelect.after(this.createOperatorField(selectedAttribute));
    columnSelect.after(sep.cloneNode(true));
  }

  rememberValue(event) {
    this.previousValues.set(event.target, event.target.value);
  }

  addFilter(e, withOperatorType = true) {
    e?.preventDefault();

    const row = document.createElement("div");
    row.className = CL.row;

    const columnSelect = this.buildColumnSelect();
    const removeButton = this.buildRemoveButton();

    row.appendChild(removeButton);
    row.appendChild(withOperatorType ? this.createOperatorTypeField() : this.createWhereField());
    row.appendChild(this.createSeparator());
    row.appendChild(columnSelect);

    this.formTarget.lastElementChild.before(row);
  }

  buildColumnSelect() {
    const select = document.createElement("select");
    select.add(new Option("Column", ""));
    this.columnsValue.forEach((col) => {
      if (!col.used) {
        select.add(new Option(col.name, col.name));
      }
    });
    select.setAttribute("data-filter-target", "selectColumn");
    select.setAttribute(
      "data-action",
      "change->filter#chooseColumn mousedown->filter#rememberValue"
    );
    select.className = CL.select;
    return select;
  }

  buildRemoveButton() {
    const button = document.createElement("button");
    button.setAttribute("data-action", "click->filter#removeFilter");
    button.className = CL.removeBtn;
    const xIcon = this.removeIconTarget.cloneNode(true);
    xIcon.classList.remove("hidden");
    xIcon.classList.add("inline-block");
    button.appendChild(xIcon);
    return button;
  }

  createInputField(selectedAttribute) {
    const input = document.createElement("input");
    input.type = INPUT_TYPE_BY_COLUMN[selectedAttribute.type] || "text";
    input.className = CL.input;
    input.name = `filter[${selectedAttribute.name}][value]`;
    return input;
  }

  createOperatorField(selectedAttribute) {
    const select = document.createElement("select");
    select.name = `filter[${selectedAttribute.name}][operator]`;
    select.className = CL.selectMuted;
    fillOperatorOptions(select, operatorsForColumnType(selectedAttribute.type));
    return select;
  }

  createOperatorTypeField() {
    const select = document.createElement("select");
    select.name = "filter[operator_types][]";
    select.className = CL.selectMuted;
    select.add(new Option("Operator Type", "and"));
    select.add(new Option("AND", "and"));
    select.add(new Option("OR", "or"));
    return select;
  }

  createWhereField() {
    const select = document.createElement("select");
    select.className = CL.selectWhere;
    select.add(new Option("Where", "Where"));
    select.disabled = true;
    return select;
  }

  removeFilter(event) {
    const row = event.currentTarget.parentElement;
    const columnName = row?.querySelector("[data-filter-target='selectColumn']")?.value;

    if (columnName) {
      this.columnsValue = this.columnsValue.map((c) =>
        c.name === columnName ? { ...c, used: false } : c
      );
    }

    row?.remove();
    this.resetOptions();
  }

  resetOptions() {
    this.selectColumnTargets.forEach((select) => {
      const value = select.value;
      select.innerHTML = "";
      select.add(new Option("Column", ""));
      this.columnsValue.forEach((col) => {
        if (!col.used || col.name === value) {
          select.add(new Option(col.name, col.name));
        }
      });
      select.value = value;
    });
  }
}
