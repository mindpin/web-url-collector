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
  LOGIN_URL      = "http://4ye.mindpin.com/account/sign_in"
  USER_INFO_URL  = "http://4ye.mindpin.com/api/user_info"
  WRITE_TAGS_URL = "http://key-value.4ye.me/write_tags"
  READ_TAGS_URL  = "http://key-value.4ye.me/read_tags"
  SHORT_URL_URL  = "http://s.4ye.me/parse"
  COOKIE_KEY     = "current_user_email"
  TAG_SCOPE      = "web_page_collector"
end

require "rest_client"
require File.expand_path("../../lib/tag_methods",__FILE__)
require File.expand_path("../../lib/auth",__FILE__)
require File.expand_path("../../lib/user_store",__FILE__)
require File.expand_path("../../lib/url_info",__FILE__)