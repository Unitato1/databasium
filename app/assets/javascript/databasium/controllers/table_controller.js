import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="table-row"
export default class extends Controller {
  static targets = [
    "deleteButton",
    "recordsPanel",
    "recordTab",
    "recordTabs",
    "addRecordForm",
    "recordTabsContent"
  ];
  connect() {
    console.log("table controller connected");
    this.selectedRecords = 0;
    this.enableUpdate = false;
    this.opened_tabs = new Map();
    this.opened_form = null;
  }

  selectRecord(e) {
    if (e.target.closest("input, label, a, button")) return;

    e.preventDefault();
    const checkbox = e.target.closest("tr").querySelector("input[type='checkbox']");

    if (checkbox) {
      this.updateDeleteButton(checkbox.checked);
      checkbox.checked = !checkbox.checked;
    }
  }

  updateDeleteButton(checked) {
    if (checked) {
      this.selectedRecords--;
    } else {
      this.selectedRecords++;
    }
    if (this.selectedRecords > 0) {
      this.deleteButtonTarget.parentElement.classList.remove("hidden");
    } else {
      this.deleteButtonTarget.parentElement.classList.add("hidden");
    }
    this.deleteButtonTarget.innerHTML = `Delete records (${this.selectedRecords})`;
  }

  resetDeleteButton() {
    this.selectedRecords = 0;
    this.deleteButtonTarget.parentElement.classList.add("hidden");
  }

  openRecordsPanel() {
    this.recordsPanelTarget.classList.remove("hidden");
  }

  closeRecordsPanel() {
    this.recordsPanelTarget.classList.add("hidden");
  }

  appendRecordCard(e) {
    const row = e.currentTarget.closest("tr");
    if (this.opened_tabs.has(row.id)) return;

    const copy = this.recordTabTarget.content.cloneNode(true);
    copy.querySelector("[data-table-target='recordTabTitle']").innerHTML = row.id;
    copy.firstElementChild.dataset.recordId = row.id;

    this.recordTabsTarget.appendChild(copy);

    const form = this.createAddRecordForm(row);
    this.opened_tabs.set(row.id, form);

    if (this.opened_form) {
      this.opened_form.classList.add("hidden");
    }
    this.opened_form = form;
    this.recordTabsContentTarget.appendChild(form);
  }

  createAddRecordForm(row) {
    const form = this.element.querySelector("#add_record").cloneNode(true);
    form.classList.remove("hidden");
    // Map all inputs once
    const inputs = {};
    form.querySelectorAll("input, select, textarea").forEach((i) => {
      const match = i.name.match(/\[(\w+)\]/); // Extracts 'name' from 'record[name]'
      if (match) inputs[match[1]] = i;
    });

    // Then the loop is super fast
    [...row.children].forEach((child) => {
      const attr = child.dataset.attributeName;
      const input = inputs[attr];
      if (!input) return;
      const value = child.textContent.trim();
      switch (input.type) {
        case "file":
          // this.showExistingFile(input, value);
          break;
        case "checkbox":
          input.checked = value === "true" || value === "1";
          break;
        case "datetime-local":
          input.value = this.toDatetimeLocal(value);
          break;
        case "date":
          input.value = this.toDate(value);
          break;
        case "time":
          input.value = this.toTime(value);
          break;
        default:
          input.value = value;
      }
    });

    return form;
  }

  openTab(e) {
    const recordId = e.currentTarget.dataset.recordId;
    if (!this.opened_tabs.has(recordId)) return;

    if (this.opened_form) {
      this.opened_form.classList.add("hidden");
    }
    const form = this.opened_tabs.get(recordId);
    form.classList.remove("hidden");
    this.opened_form = form;
  }

  showExistingFile(input, filename) {
    if (!filename) return;
    let label = input.parentElement.querySelector("[data-existing-file]");
    if (!label) {
      label = document.createElement("span");
      label.dataset.existingFile = "true";
      label.className = "text-sm text-muted ml-2";
      input.insertAdjacentElement("afterend", label);
    }
    label.textContent = `Current: ${filename}`;
  }

  toDatetimeLocal(v) {
    if (!v) return "";
    // "2025-01-15 10:30:00" | "2025-01-15T10:30:00Z" | ISO with offset
    const d = new Date(v.includes("T") ? v : v.replace(" ", "T"));
    if (isNaN(d)) return "";
    const pad = (n) => String(n).padStart(2, "0");
    return (
      `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}` +
      `T${pad(d.getHours())}:${pad(d.getMinutes())}`
    );
  }

  toDate(v) {
    if (!v) return "";
    const d = new Date(v.includes("T") ? v : v.replace(" ", "T"));
    if (isNaN(d)) return "";
    const pad = (n) => String(n).padStart(2, "0");
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
  }

  toTime(v) {
    if (!v) return "";
    // "10:30:00" or a full datetime
    const match = v.match(/(\d{2}):(\d{2})(?::(\d{2}))?/);
    return match ? match[0] : "";
  }
}
