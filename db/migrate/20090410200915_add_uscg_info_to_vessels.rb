class AddUscgInfoToVessels < ActiveRecord::Migration
  def self.up
    add_column :vessels, :imo_number, :string
    add_column :vessels, :trade_indicator, :string
    add_column :vessels, :call_sign, :string
    add_column :vessels, :hull_material, :string
    add_column :vessels, :hull_number, :string
    add_column :vessels, :builder, :string
    add_column :vessels, :hull_depth, :double
    add_column :vessels, :owner, :string
    add_column :vessels, :hull_breadth, :double
    add_column :vessels, :gross_tonnage, :double
    add_column :vessels, :net_tonnage, :double
    add_column :vessels, :issuance_date, :string
    add_column :vessels, :expiration_date, :string
    add_column :vessels, :previous_names, :string
    add_column :vessels, :previous_owners, :string
  end

  def self.down
    remove_column :vessels, :previous_owners
    remove_column :vessels, :previous_names
    remove_column :vessels, :expiration_date
    remove_column :vessels, :issuance_date
    remove_column :vessels, :net_tonnage
    remove_column :vessels, :gross_tonnage
    remove_column :vessels, :hull_breadth
    remove_column :vessels, :owner
    remove_column :vessels, :hull_depth
    remove_column :vessels, :builder
    remove_column :vessels, :hull_number
    remove_column :vessels, :hull_material
    remove_column :vessels, :call_sign
    remove_column :vessels, :trade_indicator
    remove_column :vessels, :imo_number
  end
end
