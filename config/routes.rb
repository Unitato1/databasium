Databasium::Engine.routes.draw do
  root to: "homepage#index"
  resources :homepage, only: [ :index ]

  resources :records, only: [ :index, :create ] do
    get :records, on: :collection
  end
  resources :migrations, only: [ :index, :new, :create ] do
    post :run_pending_migrations, on: :collection
    post :rollback_migration, on: :collection
  end
  resources :models, only: [ :new, :create ]
  resources :schemas, only: [ :index, :new, :create ]
end
