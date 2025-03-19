Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
   namespace :v1 do
     resources :payments, only: [:index] do
       collection do
         get :sync
         get :report
       end
     end
   end
  end

  root 'pages#index'
  get '*path', to: 'pages#index', constraints: ->(req) { !req.xhr? && req.format.html?  }

end
