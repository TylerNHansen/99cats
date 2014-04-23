# == Schema Information
#
# Table name: cats
#
#  id         :integer          not null, primary key
#  age        :integer          not null
#  birth_date :date             not null
#  color      :string(255)      not null
#  name       :string(255)      not null
#  sex        :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Cat < ActiveRecord::Base
  validates :age, :birth_date, :color, :name, :sex, presence: true
  validates :age, numericality: true
  validates_date :birth_date
  validates :sex, inclusion: { in: %w(M F)}
  validates :color, inclusion: { in: %w(red cream chocolate tabby calico)}
end
