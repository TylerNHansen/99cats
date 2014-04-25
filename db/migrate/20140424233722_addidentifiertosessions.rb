class Addidentifiertosessions < ActiveRecord::Migration
  def change
    add_column :sessions, :device_name, :string
  end
end
