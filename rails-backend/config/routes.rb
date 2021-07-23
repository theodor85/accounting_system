Rails.application.routes.draw do
  root "start#index"

  get "/start", to: "start#index"
  get "/app", to: "app#index"

  get "/conf", to: "configurator#index"
  get "/conf/refs/add", to: "reference#new"
  post "/conf/refs", to: "reference#create"
end
