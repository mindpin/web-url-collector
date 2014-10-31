class Auth
  attr_reader :store

  def initialize(login, password, context)
    @login    = login
    @password = password
    @context  = context
  end

  def login!
    @response = JSON.parse(RestClient.post(R::LOGIN_URL, params))
    find_or_create_user_store!
  end

  private

  def find_or_create_user_store!
    if @response.is_a?(Hash)
      @store = User.find_or_create_by(email: @response["email"])
      @store.update_attributes(name: @response["name"], avatar: @response["avatar"], uid: @response["id"], secret: @response["secret"])
      @store.save
      @store
    end
  end

  def params
    {user: {login: @login, password: @password}}
  end
end
