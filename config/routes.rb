# frozen_string_literal: true

Rails.application.routes.draw do
  resources :facilities
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/file_uploads', to: 'file_uploads#upload'
  resources :file_uploads, only: %i[index new]
  get '/file_uploads/:id', to: 'file_uploads#show', as: 'show_processed_file'

  get 'reports', action: 'index', controller: 'reports'
  get 'reports/lengths/:processed_file_id', action: 'lengths_for_measurement', controller: 'reports'

  get 'home', action: 'index', controller: 'home'
  get 'about', action: 'show', controller: 'home'

  root 'home#index'
end
