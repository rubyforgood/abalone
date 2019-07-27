Rails.application.routes.draw do
  resources :facilities

  get 'home', action: 'index', controller: 'home'
  get 'about', action: 'show', controller: 'home'

  root 'home#index'
end
