Rails.application.routes.draw do
  resources :facilities
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/file_uploads', to: 'file_uploads#upload'
  resources :file_uploads, only: [:index, :new]

  get 'reports', action: 'index', controller: 'reports'

  get 'home', action: 'index', controller: 'home'
  get 'about', action: 'show', controller: 'home'

  root 'home#index'
end
