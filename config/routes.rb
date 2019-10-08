Rails.application.routes.draw do
  resources :news, only: %i[index show]
end
