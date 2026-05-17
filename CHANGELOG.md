# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [0.1.0] - 2026-05-16

First public release. Databasium is a development-only Rails engine for managing and exploring Rails databases from the browser.

### Added

- **Records** — browse tables, view rows, create and update records, bulk delete
- **Migrations** — create migration files from the UI, run pending migrations, roll back individual migrations
- **Models** — generate Active Record model files with attributes, associations, and validations
- **Schema** — interactive entity-relationship diagram (ERD) synced from Active Record models
- Rails engine mounted at `/databasium` with Phlex views, Hotwire (Turbo), and Stimulus controllers
- Precompiled Tailwind CSS and importmap integration for engine assets
- Homepage with links to each section

### Security

- Boot-time abort when the gem is loaded in production, to prevent accidental use outside development
- Controller-level guard when routes are mounted outside development (renders a warning page)

### Requirements

- Ruby 3.2+
- Rails 8.0.2+
- Host app must use Active Record

[0.1.0]: https://github.com/Unitato1/databasium/releases/tag/v0.1.0
