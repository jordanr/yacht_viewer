ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes"
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome"

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.random 'random', :controller => 'welcome', :action => 'random'
  map.search 'search', :controller => 'welcome', :action => 'search'
  map.advanced_search 'advanced_search', :controller => 'welcome', :action => 'advanced_search'

  map.about 'about', :controller => 'welcome', :action => 'about'
  map.advertisers 'advertisers', :controller => 'welcome', :action => 'advertisers'
  map.buyers 'buyers', :controller => 'welcome', :action => 'buyers'
  map.brokers 'brokers', :controller => 'welcome', :action => 'brokers'
  map.developers 'developers', :controller => 'welcome', :action => 'developers'
  map.owners 'owners', :controller => 'welcome', :action => 'owners'
  map.researchers 'researchers', :controller => 'welcome', :action => 'researchers'

  # authentication stuff
#  map.signup  
#  map.login

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }
  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end
  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  map.resources :vessels
#  map.resources :advertisers
#  map.resources :developers
#  map.resources :users
#  map.resources :sessions
  
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
