# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  resources :events do
    member do
      put :join
      put :leave
    end
  end
  resources :leagues, controller: 'events', type: 'League'
  resources :tournaments, controller: 'events', type: 'Tournament'

  root 'welcome#index'
  resources :teams
  resources :matches, except: [:index] do
    member do
      patch :update_points
      put :update_points
    end
  end

  get '/events/:id/schedule', to: 'events#schedule', as: 'event_schedule'
  get '/events/:id/overview', to: 'events#overview', as: 'event_overview'

  # Use custom user controller instead of the one provided by devise
  devise_for :users, path_prefix: 'my', controllers: {
    registrations: 'users',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # Sets the devise scope to be used in the controller.
  # http://www.rubydoc.info/github/plataformatec/devise/ActionDispatch%2FRouting%2FMapper%3Adevise_scope
  devise_scope :user do

    resources :users, except: [:new, :create] do
      member do
        get 'dashboard'
        get 'link'
        get 'unlink'
      end
    end

    get '/users/:id/profile/edit', to: 'users#edit_profile', as: :user_profile_edit
    match '/users/:id/profile', to: 'users#update_profile', as: :user_profile, via: [:patch, :put]
  end

  resources :teams do
    member do
      post :assign_ownership
      post :delete_ownership
      post :delete_membership
      post :perform_action_on_multiple_members
      post :assign_membership_by_email
    end
  end

  #Define route for Create Event Button
  get "/createEvent" , to: "application#createEvent" , as: "create_Event"

  get 'imprint' => "static_pages#imprint"
end
