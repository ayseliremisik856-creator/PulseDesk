Rails.application.routes.draw do
  root "tickets#index"
  get "up" => "rails/health#show", as: :rails_health_check
  resources :tickets, only: %i[index new create show update] do
    resources :ticket_responses, only: :create
  end
  resources :brands, only: %i[create update]
  resources :sla_policies, only: %i[index create update]
  resources :agents, only: :create
end
