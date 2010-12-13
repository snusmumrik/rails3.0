Rails3::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match 'signup' => 'users#new', :as => :signup
  match 'signin' => 'sessions#new', :as => :signin
  match 'signout' => 'sessions#destroy', :as => :signout
  match 'activate/:id' => 'accounts#show', :as => :activate
  match 'forgot_password' => 'passwords#new', :as => :forgot_password
  match 'reset_password/:id' => 'passwords#edit', :as => :reset_password
  match 'change_password' => 'accounts#edit', :as => :change_password

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resource :account, :password, :session
  resources :roles

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end
  resources :users do
    member do
      put 'enable'
    end
    resource :account
    resources :roles
  end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  match '/:id' => 'contents#show'
  root :to => 'contents#show', :id => "index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
