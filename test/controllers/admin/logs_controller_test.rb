# frozen_string_literal: true

require 'test_helper'

module Admin
  class LogsControllerTest < ActionDispatch::IntegrationTest
    test 'should get index' do
      get admin_logs_index_url
      assert_response :success
    end
  end
end
