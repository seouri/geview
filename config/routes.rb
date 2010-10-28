Geview::Application.routes.draw do
  resources :tracks
  match "/graph/:chromosome/:level(/:center)" => "page#home", :as => :graph
  root :to => "page#home"
end
