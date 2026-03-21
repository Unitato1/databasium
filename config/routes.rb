Databasium::Engine.routes.draw do
  root to: "homepage#index"
  resources :homepage, only: [ :index ]

  resources :records, only: [ :index, :create ] do
    get :records, on: :collection
  end
  resources :migrations, only: [ :index, :new, :create, :show ] do
    post :run_pending_migrations, on: :collection
    post :run_migration, on: :collection
    post :rollback_migration, on: :collection
  end
  resources :models, only: [ :new, :create ] do
    get :model_data, on: :collection
    get :get_model, on: :collection
  end
  resources :schemas, only: [ :index, :new, :create ]
end
