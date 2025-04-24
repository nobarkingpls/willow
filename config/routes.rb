Rails.application.routes.draw do
  resources :territories
  resource :session
  resources :passwords, param: :token
  resources :episodes
  resources :seasons
  resources :shows
  resources :countries
  resources :actors
  resources :rights
  resources :genres
  resources :movies do
    member do
      get "export_xml", to: "movies#export_xml"
      get "yt_xml", to: "movies#yt_xml"
    end
  end

  root "welcome#index"

  get "feed.xml", to: "feeds#xml_feed", defaults: { format: "xml" }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
