Geview::Application.routes.draw do
  resources :tracks
  root :to => "page#home"
end
