Rails.application.routes.draw do
  root "start#index"

  get "/start", to: "start#index"
  get "/app", to: "app#index"

  get "/conf", to: "configurator#index"
  get "/conf/new_ref", to: "configurator#new_ref"
end
