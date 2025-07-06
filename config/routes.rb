Rails.application.routes.draw do
  get "avails/index"
  resources :territories
  resource :session
  resources :passwords, param: :token
  resources :episodes do
    member do
      get "export_xml", to: "episodes#export_xml"
      get "yt_xml", to: "episodes#yt_xml"
      post "prepare_bundle", to: "episodes#prepare_bundle", as: :prepare_bundle
    end
  end
  resources :seasons do
    member do
      get "export_xml", to: "seasons#export_xml"
      get "yt_xml", to: "seasons#yt_xml"
      post "prepare_bundle", to: "seasons#prepare_bundle", as: :prepare_bundle
    end
  end
  resources :shows do
    member do
      get "export_xml", to: "shows#export_xml"
      get "yt_xml", to: "shows#yt_xml"
      post "prepare_bundle", to: "shows#prepare_bundle", as: :prepare_bundle
    end
  end
  resources :countries
  resources :actors
  resources :rights
  resources :genres
  resources :movies do
    member do
      get "export_xml", to: "movies#export_xml"
      get "yt_xml", to: "movies#yt_xml"
      # get "itunes_xml", to: "movies#itunes_xml"
      post "prepare_bundle", to: "movies#prepare_bundle", as: :prepare_bundle
      post "prepare_itunes_bundle", to: "movies#prepare_itunes_bundle", as: :prepare_itunes_bundle
    end
  end

  root "welcome#index"

  get "feed.xml", to: "feeds#xml_feed", defaults: { format: "xml" }
  get "content_feed.xml", to: "feeds#content_feed", defaults: { format: "xml" }
  get "avail_feed.xml", to: "feeds#avail_feed", defaults: { format: "xml" }

  get "avails", to: "avails#index"

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
