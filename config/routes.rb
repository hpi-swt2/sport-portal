# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :events
  root 'welcome#index'
  resources :teams
  resources :matches

  # Use custom user controller instead of the one provided by devise
  devise_for :users, controllers: {
    registrations: 'users',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # Sets the devise scope to be used in the controller.
  # http://www.rubydoc.info/github/plataformatec/devise/ActionDispatch%2FRouting%2FMapper%3Adevise_scope
  devise_scope :user do
    resources :users, only: [:index, :show]

    get '/users/:id/dashboard', to: 'users#dashboard'
    get '/users/:id/link', to: 'users#link'
    get '/users/:id/unlink', to: 'users#unlink'
  end

  resources :users do
    # Dashboard
    get 'dashboard', on: :member
    get 'link', on: :member
    get 'unlink', on: :member

    # Avatar
    patch 'avatar', on: :member, to: 'avatars#update'
    put 'avatar', on: :member, to: 'avatars#update'
    post 'avatar', on: :member, to: 'avatars#create'
    delete 'avatar', on: :member, to: 'avatars#destroy'
  end
end
