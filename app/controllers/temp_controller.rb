class TempController < ApplicationController
  def index
    @previous_url = request.referer
  end
end
