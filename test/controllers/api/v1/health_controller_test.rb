require "test_helper"

class Api::V1::HealthControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_v1_health_show_url
    assert_response :success
  end
end
