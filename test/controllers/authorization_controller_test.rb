require "test_helper"

class AuthorizationControllerTest < ActionDispatch::IntegrationTest
  test "should get test" do
    get authorization_test_url
    assert_response :success
  end
end
