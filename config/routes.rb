Rails.application.routes.draw do
  root 'matches#index'
  resources :matches do
    member do
      get 'play', as: :play
      patch 'play_update', as: :play_update
    end
  end

  # resources :games
  resources :players

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
