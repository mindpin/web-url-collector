module TokenAuth
  def issue_token(user)
    claim = {
      :user_id => user.id,
      :nbf     => Time.now,
      :exp     => 1.month.from_now
    }

    JWT.encode(claim, Rails.application.secrets[:secret_key_base])
  end

  def auth_header
    request.headers["Authorization"]
  end

  def token
    auth_header.split(" ").last
  end
end
