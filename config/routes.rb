Rails.application.routes.draw do
  defaults format: :json do
    resources :enrollments, only: %i[show create destroy]
    resources :sections, only: %i[show create]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
