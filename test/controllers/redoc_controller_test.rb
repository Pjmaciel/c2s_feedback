require "test_helper"

class RedocControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get redoc_index_url
    assert_response :success
  end
end
