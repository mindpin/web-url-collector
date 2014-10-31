class AuthController < ApplicationController
  def check
    if signed_in?
      render nothing: true, status: 200
    else
      render nothing: true, status: 401
    end
  end

  def new
    callback = params[:callback]
    cookies.permanent["callback"] = callback if callback
    callback
  end

  def create
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


    @user = User.find_or_initialize_by(uid: uid)
    @user.update_attributes(access_token: access_token, expires_in: expires_in)
    @user.save

    set_cookie!(@user)

    if cookies["callback"]
      redirect = "#{cookies["callback"]}?auth_token=#{issue_token(@user)}"
      cookies.delete :callback
      return redirect_to redirect
    end

    redirect_to :root
  end
end
