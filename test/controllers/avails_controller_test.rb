require "test_helper"

class AvailsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get avails_index_url
    assert_response :success
  end
end
