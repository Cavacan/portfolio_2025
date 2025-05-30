# frozen_string_literal: true

require 'test_helper'

module Admin
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test 'should get new' do
      get admin_sessions_new_url
      assert_response :success
    end

    test 'should get create' do
      get admin_sessions_create_url
      assert_response :success
    end

    test 'should get destory' do
      get admin_sessions_destory_url
      assert_response :success
    end
  end
end
