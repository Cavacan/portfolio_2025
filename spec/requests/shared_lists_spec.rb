# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SharedLists', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/shared_lists/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/shared_lists/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create' do
    it 'returns http success' do
      get '/shared_lists/create'
      expect(response).to have_http_status(:success)
    end
  end
end
