Databasium::Engine.routes.draw do
  root to: "homepage#index"
  resources :homepage, only: [ :index ]

  resources :records, only: [ :index, :create ] do
    collection do
      delete :bulk_destroy
    end
    get :records, on: :collection
  end
  resources :migrations, only: [ :index, :new, :create, :show ] do
    collection do
      post :run_pending_migrations
      post :run_migration
      post :rollback_migration
    end
  end
  resources :models, only: [ :new, :create ] do
    collection do
      get :get_model
    end
  end
  resources :schemas, only: [ :index, :new, :create ] do
    collection do
      get :sidebar
    end
  end
end
