# desc "Explaining what the task does"
# task :databasium do
#   # Task goes here
# end

task :tailwind_engine_watch do
  require "tailwindcss-rails"
  # NOTE: tailwindcss-rails is an engine
  system "#{Tailwindcss::Engine.root.join("exe/tailwindcss")} \
         -i #{Databasium::Engine.root.join("app/assets/stylesheets/application.tailwind.css")} \
         -o #{Databasium::Engine.root.join("app/assets/builds/databasium.css")} \
         -c #{Databasium::Engine.root.join("config/tailwind.config.js")} \
         --minify -w"
end
