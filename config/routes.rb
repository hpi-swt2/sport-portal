# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

<<<<<<< HEAD
=======
  resources :events do
    member do
      put :join
    end
  end

>>>>>>> dev
  root 'welcome#index'
  resources :teams
  resources :matches, except: [:index] do
    member do
      patch :update_points
      put :update_points
    end
  end

  get '/events/:id/schedule', to: 'events#schedule', as: 'event_schedule'

  resources :events
  resources :leagues, controller: 'events', type: 'League'
  resources :tournaments, controller: 'events', type: 'Tournament'

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

  #Define route for user dashboard
  resources :users do
    get 'dashboard', on: :member
    get 'link', on: :member
    get 'unlink', on: :member
  end

  #Define route for Create Event Button
  get "/createEvent" , to: "application#createEvent" , as: "create_Event"

  get 'imprint' => "static_pages#imprint"
end
