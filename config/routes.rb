Databasium::Engine.routes.draw do
  root to: "homepage#index"
  resources :homepage, only: [ :index ]

  resources :records, only: [ :index, :create, :update ] do
    collection do
      get :sidebar
      delete :bulk_destroy
      get :records
    end
  end
  resources :migrations, only: [ :index, :new, :create, :show ] do
    collection do
      get :sidebar
      post :run_pending_migrations
      post :run_migration
      post :rollback_migration
    end
  end
  resources :models, only: [ :new, :create, :show ] do
    collection do
      get :sidebar
      # get :get_model
    end
  end
  resources :schemas, only: [ :index, :new, :create ] do
    collection do
      get :sidebar
      put :sync_schema
    end
  end
end
