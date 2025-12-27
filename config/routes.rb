Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post "signup", to: "auth#signup"
  post "login",  to: "auth#login"
  post "forgot_password", to: "auth#forgot_password"
  post "reset_password",  to: "auth#reset_password"
  get  "me",     to: "auth#me"

  resources :equipments do
    get :requests, on: :member
  end
  
  resources :maintenance_teams do
    post :add_member, on: :member
    delete :remove_member, on: :member
  end
  
  resources :maintenance_requests do
    member do
      post :assign_self
      post :start_work
      post :complete
      post :scrap
    end
  end  

  resources :departments
end
