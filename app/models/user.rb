# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#


class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, :session_token, uniqueness: true
  validates :password, { length: { minimum: 6, allow_nil: true } }
  before_validation :ensure_session_token

  has_many :cats
  has_many :cat_rental_requests

  attr_reader :password

  def self.find_by_credentials(user_h)
    user = User.find_by_user_name(user_h[:user_name])
    return user if user.try(:is_password?, user_h[:password])
    nil
  end

  def reset_session_token!
    self.session_token = SecureRandom.hex
    self.save!
    session_token
  end

  def password=(plain_text)
    @password = plain_text
    self.password_digest = BCrypt::Password.create(plain_text)
  end

  def is_password?(plain_text)
    BCrypt::Password.new(password_digest).is_password?(plain_text)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.hex
  end
end
