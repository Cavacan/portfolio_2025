# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::ApplicationSettings', type: :request do
  describe 'GET /edit' do
    it 'returns http success' do
      get '/admin/application_setting/edit'
      expect(response).to have_http_status(:success)
    end
  end
end
