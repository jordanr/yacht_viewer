require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "index" do
    get :index

    assert assigns(:vessels)
    assert assigns(:map)
  end

  test "search" do
    get :index, :query=>"hi"

    assert assigns(:vessels)
    assert assigns(:map)
  end

  test "show" do
    get :show, :id=>1
    assert assigns(:vessel)
#    assert assigns(:map)
  end



end
