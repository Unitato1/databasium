Databasium::Engine.routes.draw do
  root to: "homepage#index"
  resources :homepage, only: [:index]

  resources :records, only: [:index]
  resources :migrations, only: [:index, :new, :create] do
    post :run_pending_migrations, on: :collection
  end
end
