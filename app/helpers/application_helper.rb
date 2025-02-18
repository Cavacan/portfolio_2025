module ApplicationHelper
  def asset_exists?(asset)
    Rails.application.assets.find_asset(asset).present?
  end
end
