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
     # Dashboard
     get 'dashboard', to: 'dashboard#index'
     get 'dashboard/patient/:patient_id', to: 'dashboard#patient', as: :dashboard_patient
     get 'dashboard/alerts', to: 'dashboard#alerts'

     # Patients
     resources :patients do
       collection do
         get :search
       end

       # Patient medications
       resources :medications, controller: 'patient_medications'

       # Patient labs
       resources :labs, controller: 'patient_labs'

       # Patient calls
       resources :calls, controller: 'patient_calls' do
         member do
           post :complete
         end
       end
     end

     # Payments (existing)
     resources :payments, only: [:index] do
       collection do
         get :sync
         get :report
       end
     end

     # Patient Census Entries (existing)
     resources :patient_census_entries, only: [:index, :create, :show, :update, :destroy] do
       collection do
         get :stats
       end
       member do
         post :mark_called
       end
     end

     # Users (existing)
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
