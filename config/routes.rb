Rails.application.routes.draw do
  devise_for :users, path_prefix: 'app'
  resources :users
  resources :facilities
  resources :cohorts
  resources :animals
  resources :enclosures
  resources :measurement_types, except: %i[show]
  resources :animals do
    collection do
      get '/csv_upload', action: 'csv_upload'
      post '/csv_upload', action: 'import'
    end
  end
  resources :tanks do
    collection do
      get '/csv_upload', action: 'csv_upload'
      post '/csv_upload', action: 'import'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/file_uploads', to: 'file_uploads#upload'
  resources :file_uploads, only: [:index, :new, :destroy]
  get '/file_uploads/csv_index', to: 'file_uploads#csv_index', as: 'csv_index'
  get '/file_uploads/:id', to: 'file_uploads#show', as: 'show_processed_file'

  get '/file_uploads/errors/:id', to: 'file_uploads#show_processing_csv_errors', as: 'show_processing_csv_errors'

  resources :reports, only: [:index]

  resources :operations

  get 'home', action: 'index', controller: 'home'
  get 'about', action: 'show', controller: 'home'

  root 'home#index'
end
