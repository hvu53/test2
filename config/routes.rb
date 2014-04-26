Jiff::Application.routes.draw do

  match '/about' => 'static#about'
  match '/faq' => 'static#faq'
  match '/news' => 'static#news'
  match '/team' => 'static#team'
  match '/eula' => 'static#eula'
  match '/tos' => 'static#tos'
  match '/privacy' => 'static#privacy'
  match '/compete/download' => 'static#compete'
  match '/holiday' => 'static#holiday'
  match '/incentives/download' => 'static#incentives'
  
  match '/messages' => 'messages#new', :as => 'messages', :via => :get
  match '/messages' => 'messages#create', :as => 'messages', :via => :post

  resources :messages do
    collection do
      get :new
    end
  end

  resources :home do
    collection do
      get :index
    end
  end

  resources :health_plan do
    collection do
      get :index
    end
  end

  resources :partner do
    collection do
      get :index
    end
  end

  resources :employer do
    collection do
      get :index
    end
  end

  resources :static do
    collection do
      get :about
      get :news
      get :team
      get :faq
      get :careers
      get :rightnav
      get :eula
      get :privacy
      get :incentives
    end
  end

  root :to => "employer#index"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
