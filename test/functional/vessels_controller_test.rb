require 'test_helper'

class YachtBot
  def self.find(id)
    Vessel.find(id)
  end
end

class VesselsControllerTest < ActionController::TestCase
  test "show" do
    get :show, :id=>1
    assert assigns(:vessel)
    assert assigns(:map)
  end
end
