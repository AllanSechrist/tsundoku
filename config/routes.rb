Rails.application.routes.draw do
  get 'current_user/', to: 'current_user#index'
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :profiles do
    resources :shelves, only: [:index, :show, :create, :destroy, :update], shallow: true do
      resources :shelf_books, only: [:index, :create, :destroy]
    end
  end

  resources :bookclubs do
    resources :invites, only: [:index, :create], shallow: true
  end

  resources :invites, only: [:show, :update, :destroy] do
    member do
      post :accept
      post :revoke
    end
  end

  resources :owned_books, only: [:index, :show, :create, :update, :destroy]
end
