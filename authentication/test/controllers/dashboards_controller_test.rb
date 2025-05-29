require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "#show is accesible by anyone" do
    get dashboard_path
    assert_response :success
  end
end
