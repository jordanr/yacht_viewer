require 'test_helper'

class VesselTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "does not update semi or fully protected attributes" do
    vess = vessels(:one) 
    vess.update_open_attributes(sample_vessel)
    uscg_data.each_pair do |k,v|
      assert_not_equal vess.send(k), v
    end    
    semi_data.each_pair do |k,v|
      assert_not_equal vess.send(k), v
    end    
    open_data.each_pair do |k,v|
      assert_equal vess.send(k), v
    end    
  end

  test "does not update fully protected attributes" do
    vess = vessels(:one) 
    vess.update_semiopen_attributes(sample_vessel)
    uscg_data.each_pair do |k,v|
      assert_not_equal vess.send(k), v
    end    
    semi_data.each_pair do |k,v|
      assert_equal vess.send(k), v
    end    
    open_data.each_pair do |k,v|
      assert_equal vess.send(k), v
    end    
  end

  private
    def uscg_data
      {:builder=>"x", :name=>"x", :year=>13, :service=>'x', :location=>'x',
	:length=>13, :uscg_id=>13, :imo_number=>13,
	:trade_indicator=>"x", :call_sign=>"x", :hull_material=>'x',
	:hull_number=>"x", :hull_depth=>"x", :owner=>"x", :hull_breadth=>13.13,
	:gross_tonnage=>13.13, :net_tonnage=>13.13, :issuance_date=>"x",
	:expiration_date=>"x", :previous_names=>"x", :previous_owners=>"x" }
    end
 
    def semi_data
      { :price => 7, :broker=>"semi broker" }
    end

    def open_data
      {	:address=>"updated address", :latitude=>200.0, :longitude=>200.0, 
	:model=>"updated model", :make=>"updated make"}
    end

    def sample_vessel
      ans = uscg_data
      ans.merge!(open_data)
      ans.merge!(semi_data)
      ans
    end
end
