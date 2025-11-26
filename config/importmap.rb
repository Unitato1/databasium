pin "databasium/application", to: "databasium/application.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@maxgraph/core", to: "https://esm.sh/@maxgraph/core@0.21.0"

# Pin the controllers index so `import "controllers"` resolves
pin "databasium/controllers", to: "databasium/controllers/index.js"

# Auto-pin all Stimulus controllers under the namespace
pin_all_from Databasium::Engine.root.join("app/assets/javascript/databasium/controllers"), under: "databasium/controllers"
