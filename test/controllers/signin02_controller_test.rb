# frozen_string_literal: true

require 'test_helper'

class Signin02ControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get signin02_index_url
    assert_response :success
  end
end
