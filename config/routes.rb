Rails.application.routes.draw do
  devise_for :users


  authenticated :user do
    root to: "categories#index", as: :authenticated_root
  end

  unauthenticated do
    devise_scope :user do
      root to: "pages#home", as: :unauthenticated_root
    end
  end

  resources :categories do
    resources :notes
    resources :citizens, only: [:new, :create]
  end

  resources :citizens, only: [:show] do
    resources :messages, only: [:create]
  end

  patch "tile_map/update", to: "tile_maps#update", as: :update_tile

end
