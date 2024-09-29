Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: "oauth_callbacks" }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # et "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "questions#index"

  devise_scope :user do
    post "/send_email" => "oauth_callbacks#send_email"
  end

  concern :voteble do
    member do
      post :vote_up, :vote_down
      delete :recall
    end
  end

  concern :commenteble do
    post :create_comment, on: :member
  end

  resources :questions, concerns: %i[voteble commenteble] do
    resources :answers, concerns: %i[voteble commenteble], shallow: true, only: %i[ new create destroy update] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index

  mount ActionCable.server => "/cable"

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        get :answers, on: :member

        resources :answers, shallow: true, except: %i[new edit index]
      end
    end
  end
end
