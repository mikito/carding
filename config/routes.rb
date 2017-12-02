Rails.application.routes.draw do
  root :to => 'cards#new'
  resources :cards, only: [:new, :index]
end
