class AuthController < ApplicationController
  def new
  end

  def create
    store = Auth.new(params[:email], params[:password], self).login!
    set_cookie!(store)
    redirect_to("/")
  rescue
    redirect_to("/sign_in")
  end

  def destroy
    logout!
    redirect_to("/sign_in")
  end


  def weibo
    authorize_url = WeiboOauth2::AUTHORIZE_URL
    callback_url = WeiboOauth2::CALLBACK_URL
    key = WeiboOauth2::KEY

    url = "#{authorize_url}?client_id=#{key}&redirect_uri=#{callback_url}"

    redirect_to url

  end

  def callback

    code = params[:code]

    url_params = {
      :client_id => WeiboOauth2::KEY,
      :client_secret => WeiboOauth2::SECRET,
      :grant_type => 'authorization_code',
      :code => code,
      :redirect_uri => WeiboOauth2::CALLBACK_URL
    }

    url = WeiboOauth2::ACCESS_TOKEN_URL

    rx = Net::HTTP.post_form(URI.parse(url), url_params)

    body = rx.body
    body = JSON.parse(body)
    uid = body["uid"]
    access_token = body["access_token"]
    expires_in = body["expires_in"]


    p body
    p '--------========'
    p access_token
    p uid
    p expires_in

    @user = User.find_or_create_by(uid: uid)
    @user.update(access_token: access_token, expires_in: expires_in)


    p '------'
    p @user



    render :nothing => true

    
  end
end
