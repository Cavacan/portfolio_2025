require 'test_helper'

class Signin01ControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get signin01_index_url
    assert_response :success
  end

  test 'should get send_link' do
    get signin01_send_link_url
    assert_response :success
  end
end
