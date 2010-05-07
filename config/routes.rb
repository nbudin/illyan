ActionController::Routing::Routes.draw do |map|
  map.devise_for :people, :open_id_identities
  map.resources :people
end