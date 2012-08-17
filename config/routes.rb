SensuAdmin::Application.routes.draw do
  devise_for :users

  match 'users/update_password' => 'users#update_password', :via => :post

  match 'events/events_table' => 'events#events_table', :via => :get
  match 'events/:client/:check/resolve' => 'events#resolve', :via => :post
  match 'events/:client/silence' => 'events#silence_client', :via => :post
  match 'events/:client/:check/silence' => 'events#silence_check', :via => :post
  match 'events/:client/unsilence' => 'events#unsilence_client', :via => :post
  match 'events/:client/:check/unsilence' => 'events#unsilence_check', :via => :post

  match 'stashes/create_stash' => 'stashes#create_stash', :via => :post
  match 'stashes/delete_stash' => 'stashes#delete_stash', :via => :post
  match 'stashes/delete_all_stashes' => 'stashes#delete_all_stashes', :via => :post

  match 'downtimes/old_downtimes' => 'downtimes#old_downtimes', :via => :get
  match 'downtimes/force_complete' => 'downtimes#force_complete', :via => :post

  match 'checks/:check/submit' => 'checks#submit_check', :via => :post

  match 'api/status' => 'api#status', :via => :get
  match 'api/time' => 'api#time', :via => :get

  resources :events
  resources :stashes
  resources :logs
  resources :checks
  resources :downtimes
  resources :clients
  resources :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products


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
  root :to => 'events#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
