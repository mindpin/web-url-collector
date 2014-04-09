require File.expand_path("../../config/env",__FILE__)

class WebUrlCollectorApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  set :views, ["templates"]
  set :root, File.expand_path("../../", __FILE__)
  register Sinatra::AssetPack

  assets {
    serve '/js', :from => 'assets/javascripts'
    serve '/css', :from => 'assets/stylesheets'

    js :application, "/js/application.js", [
      '/js/jquery-1.11.0.min.js',
      '/js/**/*.js'
    ]

    css :application, "/css/application.css", [
      '/css/**/*.css'
    ]

    css_compression :yui
    js_compression  :uglify
  }

  set :cookie_options, :domain => nil
  helpers Sinatra::Cookies

  helpers do
    def current_store
      Auth.current_store(self)
    end

    def login?
      !current_store.blank?
    end
  end

  get "/" do
    redirect to("/login") if !current_store
    haml :index
  end

  get "/login" do
    haml :login
  end

  post "/login" do
    begin
      Auth.new(params[:login], params[:password], self).login!
      return redirect to("/")
    rescue
      redirect to("/login")
    end
  end

  get "/logout" do
    Auth.logout(self)
    redirect to("/")
  end
  
end