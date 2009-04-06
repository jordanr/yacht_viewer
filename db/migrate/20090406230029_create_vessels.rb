class CreateVessels < ActiveRecord::Migration
  def self.up
    create_table :vessels do |t|
      t.string :name
      t.integer :year
      t.string :service
      t.string :location
      t.decimal :length
      t.integer :uscg_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vessels
  end
end
