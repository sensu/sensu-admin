SensuAdmin::Application.routes.draw do
  devise_for :users

  scope 'users' do
    scope '/:id' do
      match '/update_password' => 'users#update_password', :via => :put
      match '/activate' => 'users#activate', :via => :put
    end
  end

  scope 'events' do
    match 'events_table' => 'events#events_table', :via => :get
    match 'modal_data' => 'events#modal_data', :via => :get
    scope '/:client', :constraints => { :client => /[\w.]+/ } do
      match '/silence' => 'events#silence_client', :via => :post
      match '/unsilence' => 'events#unsilence_client', :via => :post
      scope '/:check' do
        match '/resolve' => 'events#resolve', :via => :post
        match '/silence' => 'events#silence_check', :via => :post
        match '/unsilence' => 'events#unsilence_check', :via => :post
      end
    end
  end

  scope 'stashes' do
    match '/create_stash' => 'stashes#create_stash', :via => :post
    match '/delete_stash' => 'stashes#delete_stash', :via => :post
    match '/delete_all_stashes' => 'stashes#delete_all_stashes', :via => :post
  end

  scope 'downtimes' do
    match '/old_downtimes' => 'downtimes#old_downtimes', :via => :get
    match '/force_complete' => 'downtimes#force_complete', :via => :post
  end

  match 'checks/:check/submit' => 'checks#submit_check', :via => :post

  namespace :api do
    match '/status' => 'api#status', :via => :get
    match '/time' => 'api#time', :via => :get
    match '/setup' => 'api#setup', :via => :get
    match '/test_api' => 'api#test_api', :via => :post
  end

  match "settings/missing" => "settings#missing", :via => :get

  resources :events
  resources :stashes
  resources :logs
  resources :checks, :id => /.*/
  resources :downtimes
  resources :clients, :id => /.*/
  resources :users
  resources :stats
  resources :aggregates
  resources :settings

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
