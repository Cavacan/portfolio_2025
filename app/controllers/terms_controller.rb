class TermsController < ApplicationController
  def show
    if request.headers['X-Frame-Options'].present?
      render layout: false
    else
      render 'show'
    end
  end

  def embed
    render partial: 'shared/terms', layout: false
  end

  def policy; end
end
