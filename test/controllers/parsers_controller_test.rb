require "test_helper"

class ParsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get parsers_index_url
    assert_response :success
  end
end
