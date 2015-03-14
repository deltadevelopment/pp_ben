Rails.application.routes.draw do
  
  # User Routes
  post '/register' => 'users#create'
  get '/user/:id' => 'users#show'
  get '/user_by_username/:username' => 'users#get_by_username'
  put '/user/:id' => 'users#update'
  delete '/user/:id' => 'users#destroy'

  # Auth Routes
  post '/login' => 'sessions#create'
  delete '/login' => 'sessions#destroy'

  # Friends Routes
  post '/user/:id/friend/:friend_id' => 'friends#create_request'
  post '/user/:id/accept_friend/:friend_id' => 'friends#accept_request'
  get '/user/:id/friend_requests' => 'friends#list_requests'
  get '/user/:id/friends' => 'friends#list'

  delete '/user/:id/friend/:friend_id' => 'friends#destroy'

  # Message Routes
  post 'user/:sender_id/message/:receiver_id' => 'messages#new'
  post 'message/:id/reply' => 'messages#reply'
  get 'user/:sender_id/message/:receiver_id' => 'messages#show'
  delete 'message/:id' => 'messages#destroy'

  # Upload 
  get 'message/generate_upload_url' => 'messages#generate_upload_url'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
