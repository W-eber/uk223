require "test_helper"

class DebtsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get debts_create_url
    assert_response :success
  end

  test "should get update" do
    get debts_update_url
    assert_response :success
  end
end
