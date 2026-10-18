Rails.application.routes.draw do
  root "tickets#index"
  get "up" => "rails/health#show", as: :rails_health_check
  resources :tickets, only: %i[index new create show update] do
    resources :ticket_responses, only: :create
  end
  resources :brands, only: :create
  resources :agents, only: :create
end
