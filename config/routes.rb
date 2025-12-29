Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  namespace :admin do
    resources :users, only: [:index] do
      member do
        post :approve
        delete :reject
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
   namespace :v1 do
     resources :payments, only: [:index] do
       collection do
         get :sync
         get :report
       end
     end
     resources :patient_census_entries, only: [:index, :create, :show, :update, :destroy] do
       collection do
         get :stats
       end
       member do
         post :mark_called
       end
     end
     resources :users, only: [:index] do
       member do
         patch :update_role, path: 'role'
       end
     end
   end
  end

  root 'pages#index'
  get '*path', to: 'pages#index', constraints: ->(req) { !req.xhr? && req.format.html?  }

end
