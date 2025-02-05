require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get construction" do
    get pages_construction_url
    assert_response :success
  end
end
