# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  resources :events, except: [:create] do
    member do
      put :join
      put :leave
      get :team_join
    end
  end

  resources :leagues, controller: 'events', only: [:show, :new, :create, :update], type: League
  resources :tournaments, controller: 'events', only: [:show, :new, :create, :update], type: Tournament
  resources :rankinglists, controller: 'events', only: [:show, :new, :create, :update], type: Rankinglist

  root 'welcome#index'
  resources :teams
  resources :matches, except: [:index] do
    member do
      get 'game_results/:result_id/confirm', to: 'matches#confirm_scores', as: :confirm_scores
      patch :update_points
      put :update_points
      get :add_game_result
      get 'remove_game_result/:result_id', to: 'matches#remove_game_result', as: :remove_game_result
      get :edit_results
      patch :update_results
      put :update_results
    end
  end

  #get '/events/:id/team_join', to: 'events#team_join', as: 'team_join'
  get '/events/:id/overview', to: 'events#overview', as: 'event_overview'
  get '/events/:id/schedule', to: 'events#schedule', as: 'event_schedule'
  get '/events/:id/ranking', to: 'events#ranking', as: 'event_ranking'

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
        get 'notifications'
        get 'link'
        get 'unlink'
        post 'delete', to: 'users#confirm_destroy'
      end
    end

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

  get 'imprint' => "static_pages#imprint"
end
