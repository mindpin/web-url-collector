class UserStore
  include Mongoid::Document
  include Mongoid::Timestamps

  field :secret, type: String
  field :uid,    type: String
  field :name,   type: String
  field :email,  type: String
  field :avatar, type: String

end
