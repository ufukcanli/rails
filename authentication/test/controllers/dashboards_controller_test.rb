require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "#show redirects unauthenticated users" do
    get dashboard_path
    assert_redirected_to new_session_path
  end

  test "should get #show" do
    sign_in users(:ufuk)
    get dashboard_path
    assert_response :success
  end
end
