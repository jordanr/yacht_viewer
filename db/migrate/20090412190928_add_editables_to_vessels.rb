class AddEditablesToVessels < ActiveRecord::Migration
  def self.up
    add_column :vessels, :make, :string
    add_column :vessels, :model, :string
    add_column :vessels, :price, :integer
    add_column :vessels, :broker, :string
  end

  def self.down
    remove_column :vessels, :broker
    remove_column :vessels, :price
    remove_column :vessels, :model
    remove_column :vessels, :make
  end
end
