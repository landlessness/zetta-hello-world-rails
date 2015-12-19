Rails.application.routes.draw do
  resources :servers do
    resources :devices
  end
  root 'welcome#index'
end
