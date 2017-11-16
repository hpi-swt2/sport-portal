# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'welcome#index'
  resources :teams
  resources :matches

  # Use custom user controller instead of the one provided by devise
  devise_for :users, :controllers => { registrations: 'users' } do

  end
  
  resources :users do
	patch 'avatar', on: :member, to: 'avatars#update'
	put 'avatar', on: :member, to: 'avatars#update'
	delete 'avatar', on: :member, to: 'avatars#destroy'
  end

  # Sets the devise scope to be used in the controller.
  # http://www.rubydoc.info/github/plataformatec/devise/ActionDispatch%2FRouting%2FMapper%3Adevise_scope
  devise_scope :user { resources :users, only: [:index, :show] }
end
