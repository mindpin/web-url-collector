Rails.application.routes.draw do
  root to: "home#show"

  get  "/sign_in",     to: "auth#new"
  post "/sign_in",     to: "auth#create"
  get  "/sign_out",    to: "auth#destroy"
  get  "/auth/:provider/callback",    to: "auth#callback"
  get  "/auth/weibo",  to: "auth#weibo"

  get  "/get_plugin",  to: "url_infos#plugin"
  resources :url_infos

  namespace :api do
    get "/current_user", to: "user#info"
    post "/collect_url", to: "url_infos#create"
    get  "/check_url",   to: "url_infos#check"
    get  "/auth_check",  to: "auth#check"
  end
end
