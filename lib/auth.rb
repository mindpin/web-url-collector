require "cgi"

class Auth
  URL        = "http://4ye.mindpin.com/account/sign_in"
  COOKIE_KEY = "current_user_email"

  def initialize(login, password, context)
    @login    = login
    @password = password
    @context  = context
  end

  def login!
    @response = JSON.parse(RestClient.post(URL, params))
    find_or_create_user_store!
    set_cookie!
    asyn_secret
    true
  end

  def self.current_store(context)
    email = context.cookies[COOKIE_KEY]
    return if !email
    UserStore.where(email: CGI.unescape(email)).first
  end

  def self.logout(context)
    context.cookies.delete COOKIE_KEY
  end

  private

  def set_cookie!
    @context.cookies[COOKIE_KEY] = @store.email
  end

  def asyn_secret
    if @store.secret.blank?
      user_info = JSON.parse(RestClient.get(asyn_secret_url(@store.email)))
      @store.secret = user_info["secret"]
      @store.save
    end
  end

  def find_or_create_user_store!
    if @response.is_a?(Hash)
      @store = UserStore.find_or_create_by(email: @response["email"])
      @store.update_attributes(name: @response["name"], avatar: @response["avatar"], uid: @response["id"])
      @store.save
    end
  end

  def params
    {user: {login: @login, password: @password}}
  end

  def asyn_secret_url(email)
    "http://key-value.4ye.me/user_info?email=#{email}"
  end
end
