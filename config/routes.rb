# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'welcome#index'
  resources :teams
  resources :matches
  resources :players

  # Use custom user controller instead of the one provided by devise
  devise_for :users, :controllers => { registrations: 'users' }
  # Sets the devise scope to be used in the controller.
  # http://www.rubydoc.info/github/plataformatec/devise/ActionDispatch%2FRouting%2FMapper%3Adevise_scope
  devise_scope :user { resources :users, only: [:index, :show] }
end
