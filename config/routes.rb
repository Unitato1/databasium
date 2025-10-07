Databasium::Engine.routes.draw do
  root to: "homepage#index"
  resources :homepage, only: [:index]

  resources :records, only: [:index]
end
