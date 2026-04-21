import { Controller } from "@hotwired/stimulus";

const SPACES_UP_TO_OPEN_FORM = 135;
const CLICK_DELAY = 200;

// Connects to data-controller="table-row"
export default class extends Controller {
  static targets = [
    "deleteButton",
    "recordsPanel",
    "recordTab",
    "recordTabs",
    "addRecordForm",
    "recordTabsContent",
    "toggleAllRecordsButton",
    "checkbox"
  ];
  connect() {
    this.selectedRecords = 0;
    this.enableUpdate = false;
    this.opened_tabs = new Map();
    this.opened_form = null;
    this.opened_tab = null;
    this.opened_record_id = null;
    this.allRecordsSelected = false;
    this.clickTimer = null;
  }

  handleClick(e) {
    if (this.clickTimer === null) {
      this.clickTimer = setTimeout(() => {
        this.clickTimer = null;
        this.selectRecord(e);
      }, CLICK_DELAY);
    } else {
      clearTimeout(this.clickTimer);
      this.clickTimer = null;
      this.appendRecordCard(e);
    }
  }
  selectRecord(e) {
    const tr = e.target.closest("tr");
    if (!tr) return;
    const checkbox = tr.querySelector("input[type='checkbox']");
    if (!checkbox) return;
    if (!e.target.closest("input, label, a, button")) {
      checkbox.checked = !checkbox.checked;
    }
    this.updateDeleteButton(checkbox.checked);
    this.allRecordsSelected = this.checkboxTargets.length === this.selectedRecords;
    this.updateStyleOfToggleAllRecordsButton();
  }

  toggleAllRecords() {
    // this.allRecordsSelected = !this.allRecordsSelected;
    this.checkboxTargets.forEach((checkbox) => {
      checkbox.checked = !this.allRecordsSelected;
    });
    this.allRecordsSelected = !this.allRecordsSelected;
    this.updateStyleOfToggleAllRecordsButton();
    this.updateDeleteButtonAllRecordsSelected();
    this.updateDeleteButtonText();
  }

  updateStyleOfToggleAllRecordsButton() {
    if (this.allRecordsSelected) {
      this.toggleAllRecordsButtonTarget.classList.add("text-selected");
    } else {
      this.toggleAllRecordsButtonTarget.classList.remove("text-selected");
    }
  }

  updateDeleteButtonAllRecordsSelected() {
    if (this.allRecordsSelected) {
      this.selectedRecords = this.checkboxTargets.length;
    } else if (this.allRecordsSelected === false) {
      this.selectedRecords = 0;
    }
    this.updateDeleteButtonText();
  }

  updateDeleteButton(checked) {
    if (!checked) {
      this.selectedRecords--;
    } else {
      this.selectedRecords++;
    }
    this.updateDeleteButtonText();
  }

  updateDeleteButtonText() {
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
    this.openRecordsPanel();
    const row = e.currentTarget.closest("tr");
    if (this.opened_tabs.has(row.id)) {
      this.openTab(e, row.id);
      this.scrollToOpenedTab();
      return;
    }
    this.opened_record_id = row.id;
    if (this.opened_form === null) {
      this.recordTabsContentTarget.innerHTML = "";
    }

    if (this.opened_tab) {
      this.opened_tab.classList.remove("bg-accent");
    }

    const copy = this.recordTabTarget.content.cloneNode(true);
    copy.firstElementChild.querySelector("[data-table-target='recordTabTitle']").innerHTML = row.id;
    copy.firstElementChild.dataset.recordId = row.id;
    copy.firstElementChild.classList.add("bg-accent");
    this.opened_tab = copy.firstElementChild;
    this.recordTabsTarget.appendChild(copy);
    this.scrollToOpenedTab();

    const form = this.createAddRecordForm(row);
    this.opened_tabs.set(row.id, form);

    if (this.opened_form) {
      this.opened_form.classList.add("hidden");
    }
    this.opened_form = form;
    this.recordTabsContentTarget.appendChild(form);
  }

  scrollToOpenedTab() {
    this.opened_tab.scrollIntoView({
      behavior: "smooth",
      block: "nearest",
      inline: "end"
    });
  }

  createAddRecordForm(row) {
    const form = this.element.querySelector("#addRecord").cloneNode(true);
    form.classList.remove("hidden", "max-h-100");
    // 135px is the space up to the open form cant define as constants because of tailwind dynamic classes
    form.classList.add(`max-h-[calc(100dvh-135px)]`, "pb-6");
    const addRecordButton = form.querySelector("#add_record_button");
    addRecordButton.value = `Update record ${row.id}`;
    const inputs = {};
    form.method = "patch";
    form.action = `/databasium/records/${row.id.split("_")[1]}`;

    form.querySelectorAll("input, select, textarea").forEach((i) => {
      const match = i.name.match(/\[(\w+)\]/);
      if (match) inputs[match[1]] = i;
    });

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

  openTab(e, givenRecordId = null) {
    const recordId = givenRecordId || e.currentTarget.dataset.recordId;
    if (!this.opened_tabs.has(recordId)) return;
    this.opened_record_id = recordId;
    if (this.opened_tab) {
      this.opened_tab.classList.remove("bg-accent");
    }

    if (this.opened_form) {
      this.opened_form.classList.add("hidden");
    }
    const form = this.opened_tabs.get(recordId);

    const recordTab = this.recordTabsTarget.querySelector(`[data-record-id="${recordId}"]`);
    recordTab.classList.add("bg-accent");
    this.opened_tab = recordTab;

    form.classList.remove("hidden");
    this.opened_form = form;
  }

  closeTab(e) {
    const recordTab = e.currentTarget.parentElement;
    const recordId = recordTab.dataset.recordId;

    if (!this.opened_tabs.has(recordId)) return;

    recordTab.remove();
    this.opened_tabs.get(recordId).remove();

    this.opened_tabs.delete(recordId);

    if (this.opened_record_id === recordId) {
      this.opened_tab.remove();
      this.opened_form.remove();
      this.opened_form = null;
      this.opened_tab = null;
      this.opened_record_id = null;
    }
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
    const match = v.match(/(\d{2}):(\d{2})(?::(\d{2}))?/);
    return match ? match[0] : "";
  }
}
