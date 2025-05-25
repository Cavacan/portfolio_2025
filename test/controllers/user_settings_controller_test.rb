# frozen_string_literal: true

require 'test_helper'

class UserSettingsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get user_settings_index_url
    assert_response :success
  end
end
