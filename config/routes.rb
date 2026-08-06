Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :categories do
    resources :notes
    resources :citizens, :only [:new, :create]
  end

  resources :citizens, :only [:show] do
    resources :messages, :only [:create]
  end

end
