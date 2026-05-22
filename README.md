# Databasium

Databasium is a Rails engine that gives you a browser UI for working with your database during local development. Browse and edit records, write and run migrations, generate Active Record models, and visualize your schema as an entity-relationship diagram (ERD).

**Development only.** Databasium writes files under `db/migrate` and `app/models` and is not safe to expose publicly. Do not EVER use it in production. Databasium tries to guard this on its own so it might crash you app if you forget about it. Is should be easy to test locally, just run:

```bash
RAILS_ENV=production bin/rails s
```

## Requirements

- Ruby 3.2+
- Rails 8.0.2+
- A Rails app with **Active Record** models
- importmap-rails, turbo-rails, and stimulus-rails (installed automatically with the gem)
- Databasium ships precompiled CSS and registers its own importmap pins.

## Installation

IMPORTANT: Add the gem to your **development** group only:

```ruby
# Gemfile
group :development do
  gem "databasium"
end
```

Then install and mount the engine:

```bash
bundle install
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount Databasium::Engine, at: "/databasium" if Rails.env.development?

  # ...
end
```

Visit [http://localhost:3000/databasium](http://localhost:3000/databasium) while running `bin/rails server` in development.

The mount path is detected automatically from your routes. To override (optional):

```ruby
config.databasium.mount_path = "/admin/database"
```

Pending-migration blocking is skipped only under the Databasium mount so you can run migrations from the UI; the rest of your app still shows the normal Rails pending-migration page.

### Production safety

When `databasium` is in `group :development`, Bundler does not load it in production, so your app boots normally in production.

If the gem is loaded in production (for example, added outside the development group), Databasium aborts on boot to prevent accidental use.

## Features

| Area           | Description                                               |
| -------------- | --------------------------------------------------------- |
| **Records**    | CRUD interface for table data                             |
| **Migrations** | Create migration files, run pending migrations, roll back |
| **Models**     | Generate Active Record model files from the UI            |
| **Schema**     | ERD view synced from your models                          |

Routes are mounted under `/databasium` (for example `/databasium/records`, `/databasium/migrations`)...

## Developing the gem

Clone the repository and install dependencies:

```bash
git clone https://github.com/Unitato1/databasium.git
cd databasium
bundle install
```

The engine is developed against the dummy app in `test/dummy`. Prepare its database:

```bash
./test/dummy/bin/rails db:migrate
./test/dummy/bin/rails db:seed
```

Start the server from the gem root (this also watches and rebuilds Tailwind CSS):

```bash
bin/rails server
```

Open [http://127.0.0.1:3000/databasium](http://127.0.0.1:3000/databasium).

## Status

Version **0.1.1** is an early release. Automated test coverage is limited; treat the API and UI as subject to change.

## Contributing

I will be happy for any bug reports and pull requests.

I am open for updating and working on any changes in the future if there would be interest.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
