module ApplicationHelper
  def current_store
    email = cookies.signed[R::COOKIE_KEY] 
    return if !email
    User.where(email: CGI.unescape(email)).first
  end

  def signed_in?
    !current_store.blank?
  end

  def logout!
    cookies.delete R::COOKIE_KEY
  end

  def get_plugin_script
    secret = current_store.secret
    site = request.url.sub request.path_info, ''
    "javascript:void(function(d){window.USER_SECRET='#{secret}';window.M4YE_SITE='#{site}/';var l=function(u){var e=d.createElement('script');e.setAttribute('type','text/javascript');e.setAttribute('charset','UTF-8');e.setAttribute('src',u);d.body.appendChild(e)};l(window.M4YE_SITE+'web-url-collector.js?r='+Math.random())}(document));"
  end

  protected

  def set_cookie!(store)
    cookies.permanent.signed[R::COOKIE_KEY] = store.email
  end

  def find_by_secret(secret)
    return if secret.blank?
    store = User.where(secret: secret).first
    return store if !store.blank?
    return create_user_store_by_info(secret)
  end

  def user_info_url(value)
    "#{R::USER_INFO_URL}?secret=#{value}"
  end

  def create_user_store_by_info(secret)
    user_info = JSON.parse(RestClient.get(user_info_url(secret)))
    return if user_info["email"].blank?
    store = User.find_or_create_by(email: user_info["email"])
    store.update_attributes(name: user_info["name"], avatar: user_info["avatar"], uid: user_info["id"], secret: user_info["secret"])
    store.save
    store
  end
end
