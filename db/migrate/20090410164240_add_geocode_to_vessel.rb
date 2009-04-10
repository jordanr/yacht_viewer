class AddGeocodeToVessel < ActiveRecord::Migration
  def self.up
    add_column :vessels, :address, :string
    add_column :vessels, :latitude, :double
    add_column :vessels, :longitude, :double
  end

  def self.down
    remove_column :vessels, :longitude
    remove_column :vessels, :latitude
    remove_column :vessels, :address
  end
end
