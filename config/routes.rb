Rails.application.routes.draw do
  default_url_options host: ENV.fetch("host"), protocol: ENV.fetch("protocol")
  root to: "posts#index"

  # User
  resource :profile, controller: "developers", only: %i[update edit]
  resources :developers, path: "/authors", only: "show"

  # Posts
  resources :posts, except: :destroy, param: :titled_slug do
    post :like
    post :unlike
    post :preview, on: :collection
    get "/:titled_slug.md", to: "posts#show", as: "post_text"
  end

  get :random, to: "posts#random", as: :random
  get "/posts_drafts", to: "posts#drafts", as: :drafts

  # Stats
  resources :statistics, only: :index

  # Sessions
  if !Rails.env.production?
    get "/admin", to: "sessions#new"
    post "/auth/developer/callback", to: "sessions#create"
  end

  get "/admin" => redirect("/auth/google_oauth2")
  post "/auth/google_oauth2", as: "google_oauth2"
  post "/auth/google_oauth2/callback", to: "sessions#create"
  get "account/signout", to: "sessions#destroy"

  # Channels
  resources :channels, path: "/", only: :show
end
