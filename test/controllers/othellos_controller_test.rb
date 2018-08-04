require 'test_helper'

class OthellosControllerTest < ActionDispatch::IntegrationTest
  test "should get reception" do
    get othellos_reception_url
    assert_response :success
  end

end
