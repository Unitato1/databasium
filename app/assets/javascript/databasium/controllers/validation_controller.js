import { Controller } from "@hotwired/stimulus";

const BASIC_INFO = {
  presence:
    'Ensures the attribute is not blank — i.e. not nil and not an empty or whitespace-only string. Default error: "can\'t be blank".',
  absence:
    'Ensures the attribute is blank — i.e. nil or an empty/whitespace-only string. Often used with conditional validations (e.g. `if: :invited?`). Default error: "must be blank".',
  uniqueness:
    'Ensures the attribute\'s value is unique across rows by running a SELECT before save. Supports `:scope`, `:case_sensitive`, and `:conditions`. Note: this is not a DB constraint — add a unique index too. Default error: "has already been taken".',
  inclusion:
    "Ensures the attribute's value is in a given set passed via `:in` (array, range, proc, or lambda). Uses `Range#cover?` for ranges, otherwise `include?`.",
  exclusion:
    "Ensures the attribute's value is NOT in a given set passed via `:in` (array, range, proc, or lambda). Mirror of `inclusion`.",
  validates_associated:
    'Calls `valid?` on each associated object when this record is validated. Use only on one side of an association to avoid infinite loops. Default error: "is invalid".',
  numericality:
    "Ensures the attribute is a number. Use `only_integer: true` to require integers, plus comparison options (`:greater_than`, `:less_than`, `:in`, `:odd`, `:even`, etc.). Doesn't allow nil unless `allow_nil: true`.",
  length:
    "Validates the length of the attribute. Use `:minimum`, `:maximum`, `:in` (range), or `:is`. Customize messages with `:too_short`, `:too_long`, `:wrong_length`.",
  acceptance:
    "Validates that a checkbox was checked (e.g. terms of service). Creates a virtual attribute if no DB column exists. `:accept` defaults to `['1', true]`. Default error: \"must be accepted\".",
  confirmation:
    'Validates that two fields match — e.g. `email` and `email_confirmation`. Adds a virtual `_confirmation` attribute. Use `case_sensitive: false` to ignore case. Default error: "doesn\'t match confirmation".',
  comparison:
    "Validates a comparison between two comparable values via `:greater_than`, `:greater_than_or_equal_to`, `:equal_to`, `:less_than`, `:less_than_or_equal_to`, or `:other_than`. Each option accepts a value, proc, or symbol.",
  format:
    'Validates the attribute against a regular expression via `:with` (must match) or `:without` (must not match). Prefer `\\A` and `\\z` over `^`/`$`. Default error: "is invalid".'
};
const PRESELECTED_TYPE = "presence";
// Connects to data-controller="validation"
export default class extends Controller {
  static targets = ["valueInput", "basicInfo", "basicInfoText"];

  static values = {
    selectedType: String
  };
  connect() {
    this.selectedType = this.selectedTypeValue || PRESELECTED_TYPE;
    this.valueInputTarget.setAttribute("list", `${this.selectedType}-options`);
  }

  updateType(event) {
    this.selectedType = event.target.value;
    this.valueInputTarget.setAttribute("list", `${this.selectedType}-options`);
  }

  allowNil() {
    const value = this.valueInputTarget.value;
    const isEmpty = value.trim() === "";
    this.valueInputTarget.value = `${value} ${isEmpty ? "" : ","} allow_nil: true`;
  }

  allowBlank() {
    const value = this.valueInputTarget.value;
    const isEmpty = value.trim() === "";

    this.valueInputTarget.value = `${value} ${isEmpty ? "" : ","} allow_blank: true`;
  }

  onAction() {
    const value = this.valueInputTarget.value;
    const isEmpty = value.trim() === "";
    this.valueInputTarget.value = `${value} ${isEmpty ? "" : ","} on: :action`;
  }

  remove() {
    this.element.remove();
  }

  showBasicInfo() {
    this.basicInfoTarget.classList.remove("hidden");
    this.basicInfoTextTarget.textContent = BASIC_INFO[this.selectedType] || "";
  }

  hideBasicInfo() {
    this.basicInfoTarget.classList.add("hidden");
  }
}
