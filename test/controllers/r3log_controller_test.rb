require "test_helper"

class R3logControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get r3log_top_url
    assert_response :success
  end

  test "should get about" do
    get r3log_about_url
    assert_response :success
  end
end
