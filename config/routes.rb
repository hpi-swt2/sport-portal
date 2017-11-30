# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  resources :events do
    member do
      put :join
    end
  end

  root 'welcome#index'
  resources :teams
  resources :matches, except: [:index] do
    member do
      patch :update_points
      put :update_points
    end
  end

  get '/events/:id/schedule', to: 'events#schedule', as: 'event_schedule'

  # Use custom user controller instead of the one provided by devise
  devise_for :users, controllers: {
    registrations: 'users',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # Sets the devise scope to be used in the controller.
  # http://www.rubydoc.info/github/plataformatec/devise/ActionDispatch%2FRouting%2FMapper%3Adevise_scope
  devise_scope :user do
    resources :users do
      member do
        patch 'avatar', to: 'avatars#update'
        put 'avatar', to: 'avatars#update'
        post 'avatar', to: 'avatars#create'
        delete 'avatar', to: 'avatars#destroy'
      end
    end

    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get 'dashboard'
        get 'link'
        get 'unlink'
      end
    end
  end

  resources :teams do
    member do
      post :assign_ownership
      post :delete_ownership
      post :delete_membership
    end
  end
    
  #Define route for Create Event Button
  get "/createEvent" , to: "application#createEvent" , as: "create_Event"

  get 'imprint' => "static_pages#imprint"
end
