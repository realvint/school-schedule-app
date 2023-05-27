class User < ApplicationRecord
  include Roleable

  devise :invitable, :database_authenticatable, :registerable, :trackable,
         :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]

  def self.from_omniauth(access_token)
    user = User.where(email: access_token.info.email).first

    user ||= User.create(
      email: access_token.info.email,
      password: Devise.friendly_token[0, 20]
    )
    user
  end

  after_create do
    # assign default role
    self.update(student: true)
  end

  def to_s
    email
  end
end
