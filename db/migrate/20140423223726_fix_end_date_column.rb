class FixEndDateColumn < ActiveRecord::Migration
  def change
    change_column :cat_rental_requests, :end_date, :date
  end
end
