require "test_helper"

class Api::TestControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test "should throw unauthorized error if not logged in" do
    get api_test_url
    assert_response :unauthorized
  end

  test "should respond ok and the json, when logged in" do
    sign_in @user
    get api_test_url
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal "hello from authorized endpoint", json_response["payload"]
  end
end
