Rails.application.routes.draw do
  resources :aws_keys
  resources :bucket_configs
  get 'welcome/home'
  root 'welcome#home'
  devise_for :users, controllers: { registrations: "registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
