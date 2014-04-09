require "bundler"
Bundler.setup(:default)
require "sinatra"
require "sinatra/cookies"
require "sinatra/reloader"
require 'sinatra/assetpack'
require "pry"
require 'haml'
require 'sass'
require 'coffee_script'
require 'yui/compressor'
require 'sinatra/json'
require 'mongoid'
Mongoid.load!("./config/mongoid.yml")

ENV_YAML = YAML.load_file("config/env.yml")
class R
end

require "rest_client"
require File.expand_path("../../lib/auth",__FILE__)
require File.expand_path("../../lib/user_store",__FILE__)
require File.expand_path("../../lib/url_info",__FILE__)