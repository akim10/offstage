Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, only: [:new, :create, :edit, :select_current_genre, :toggle_notifications, :toggle_announcement_notifications]
  resources :users do
    collection do
        put :select_current_genre, :path => "genres"
        patch :toggle_notifications
        patch :toggle_announcement_notifications
      end
  end

  resources :songs, only: [:new, :create, :edit, :destroy, :search]
  get 'songs/destroy'
  get 'songs/search'
  resources :songs do
    collection do
      get :voting
      post :submit_vote
      get :search
    end
  end
  get 'home/index'
  resources :home do
    collection do
        # patch :select_current_genre
        get :notifications
        get :clear_notification
      end
  end
  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end


