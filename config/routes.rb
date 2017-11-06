Rails.application.routes.draw do
  # Use custom registrations controller instead of the one provided by devise
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'welcome#index'

  resources :teams
  resources :matches
  resources :players
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
