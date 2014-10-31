class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid,          type: String
  field :name,         type: String
  field :email,        type: String
  field :avatar,       type: String
  field :token,        type: String
  field :access_token, type: String
  field :expires_in,   type: DateTime

  has_many :url_infos

  before_create :set_token!

  def set_token!
    self.token = Base64.encode64 self.uid
  end
end
