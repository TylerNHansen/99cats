# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  token      :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Session < ActiveRecord::Base
  validates :user_id, :token, presence: true
  validates :token, uniqueness: true

  belongs_to :user

  def self.find_user(session_token)
    self.find_by(token: session_token).try(:user)
  end

  def self.make_session(userid)
    temp_token = SecureRandom.hex
    self.create(user_id: userid, token: temp_token)
    temp_token
  end

  # def reset_session_token!
  #   self.token = SecureRandom.hex
  #   self.save!
  #   token
  # end

  def ensure_session_token
    self.token ||= SecureRandom.hex
  end
end
