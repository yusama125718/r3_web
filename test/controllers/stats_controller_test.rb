require "test_helper"

class StatsControllerTest < ActionDispatch::IntegrationTest
  test "should get single" do
    get stats_single_url
    assert_response :success
  end

  test "should get double" do
    get stats_double_url
    assert_response :success
  end
end
