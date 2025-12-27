Databasium::Engine.routes.draw do
  root to: "homepage#index"
  resources :homepage, only: [:index]

  resources :records, only: [:index, :create]
  resources :migrations, only: [:index, :new, :create] do
    post :run_pending_migrations, on: :collection
  end

  resources :schemas, only: [:index, :new, :create]
end
