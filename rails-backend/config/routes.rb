Rails.application.routes.draw do
  root "start#index"

  get "/start", to: "start#index"
  get "/app", to: "app#index"
  get "/conf", to: "configurator#index"
end
