Geview::Application.routes.draw do
  resources :tracks
  match "/graph/:chromosome/:level(/:center)" => "page#graph", :as => :graph
  root :to => "page#home"
end
