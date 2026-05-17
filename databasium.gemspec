require_relative "lib/databasium/version"

Gem::Specification.new do |spec|
  spec.name        = "databasium"
  spec.version     = Databasium::VERSION
  spec.authors     = [ "Róbert Švihla" ]
  spec.email       = [ "robertsvihla@gmail.com" ]
  spec.homepage    = "https://github.com/Unitato1/databasium"
  spec.summary     = "Databasium is a tool for managing your database."
  spec.description = "Databasium is a Rails engine for helping Rails developers with managing database.
    It provides Rails application with 4 primary resources:
    - Records: to create, read, update and delete data in your database.
    - Migrations: to manage database migrations.
    - Models: to manage Active Record models.
    - Schema: generates entity-relationship diagram(ERD) of database from Active Record models.
    It is intended to be used only in development environment.
    It is not meant to be used in production.
    For security reasons it will try to abort application when it is tried to be used in production, just to be sure :). "
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.2"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Unitato1/databasium"
  spec.metadata["changelog_uri"] = "https://github.com/Unitato1/databasium/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md", "CHANGELOG.md"]
  end

  spec.add_dependency "rails", ">= 8.0.2"
  spec.add_dependency "heroicon", "~> 1.0"
  spec.add_dependency "pagy", "~> 43.2"
  spec.add_dependency "phlex-rails", "~> 2.4"
  spec.add_dependency "turbo-rails", "~> 2.0"
  spec.add_dependency "stimulus-rails", "~> 1.3"
  spec.add_dependency "importmap-rails", "~> 2.0"
end
