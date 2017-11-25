# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :events
  root 'welcome#index'
  resources :teams
  resources :matches

  # Use custom user controller instead of the one provided by devise
  devise_for :users, :controllers => { registrations: 'users' }

  # Sets the devise scope to be used in the controller.
  # http://www.rubydoc.info/github/plataformatec/devise/ActionDispatch%2FRouting%2FMapper%3Adevise_scope
  devise_scope :user do
    resources :users, only: [:index, :show]
    get '/users/:id/dashboard', to: "users#dashboard"
    
    get '/users/:id/profile/edit', to: 'users#edit_profile', as: :user_profile_edit
    match '/users/:id/profile', to: 'users#update_profile', as: :user_profile, via: [:patch, :put]
  end

  #Define route for user dashboard
  resources :users do
    get 'dashboard', on: :member
  end
end
