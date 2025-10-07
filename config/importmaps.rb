pin "databasium/application", to: "databasium/application.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from Databasium::Engine.root.join("app/assets/javascript/databasium/controllers"), under: "controllers"
