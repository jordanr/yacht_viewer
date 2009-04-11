require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "index" do
    get :index
    assert assigns(:map)
  end

  test "about" do
    get :about

    assert assigns(:map)
  end

  test "search" do
    get :search, :query=>"hi"

    assert assigns(:vessels)
    assert assigns(:map)
  end
end
