# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  created_at :datetime
#  updated_at :datetime
#  status     :string(255)
#

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates_date :start_date, :end_date
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED) }
  validates :start_date, :end_date, :timeliness =>
  {on_or_after: lambda{Date.current}}
  validates :start_date, :timeliness => {on_or_before: :end_date}

  belongs_to :cat

  before_validation :set_defaults

  def approve!
    unless overlapping_approved_requests.empty? && self.status == 'PENDING'
      raise 'already rented or denied'
    end

    self.status = 'APPROVED'

    self.class.transaction do
      self.save!
      overlapping_pending_requests.each do |req|
        req.deny!
      end
    end

  end

  def deny!
    raise 'already approved that rental!' if self.status == 'APPROVED'
    self.status = 'DENIED'
    self.save!
  end

  private

  def set_defaults
    self.status ||= 'PENDING'
  end

  def overlapping_approved_requests
    overlapping_requests.select { |req| req.status == 'APPROVED' }
  end

  def overlapping_pending_requests
    overlapping_requests.select { |req| req.status == 'PENDING' }
  end

  def overlapping_requests
    query = <<-SQL
      SELECT
        *
      FROM
        cat_rental_requests
      WHERE
        (start_date BETWEEN ? AND ? OR end_date BETWEEN ? AND ?)
      AND
        cat_id = ?
      AND
        id != ?
    SQL
    CatRentalRequest.find_by_sql( [
      query,
      start_date, end_date,
      start_date, end_date,
      cat_id,
      id
      ]
    )
  end

end
