Rails.application.routes.draw do
  resources :exit_types
  devise_for :users, path_prefix: 'app'
  resources :users

  resources :passwords, only: [:edit, :update]
  resources :facilities do
    resources :locations
  end
  resources :cohorts
  resources :cohort_imports, only: [:create, :new]
  resources :measurement_types
  resources :animals do
    collection do
      get '/csv_upload', action: 'csv_upload'
      post '/csv_upload', action: 'import'
    end
  end
  resources :enclosures do
    collection do
      get '/csv_upload', action: 'csv_upload'
      post '/csv_upload', action: 'import'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :measurements
  post '/file_uploads', to: 'file_uploads#upload'
  resources :file_uploads, only: [:index, :new, :destroy]
  get '/file_uploads/csv_index', to: 'file_uploads#csv_index', as: 'csv_index'
  get '/file_uploads/:id', to: 'file_uploads#show', as: 'show_processed_file'

  get '/file_uploads/errors/:id', to: 'file_uploads#show_processing_csv_errors', as: 'show_processing_csv_errors'

  # resources :reports, only: [:index] # Replaced by blazer reporting - 1/24/21

  resources :operations, only: [:index]

  get 'home', action: 'index', controller: 'home'
  get 'about', action: 'show', controller: 'home'

  # mount ReportsKit::Engine, at: '/' # Replaced by blazer reporting - 1/24/21

  authenticate :user do
    mount Blazer::Engine, at: "blazer", as: 'reports'
  end

  root 'home#index'
end
