module ApplicationHelper
  def asset_exists?(asset_path)
    if Rails.application.config.assets.compile
      Rails.application.assets&.find_asset(asset_path).present?
    else
      Rails.application.assets_manifest.files.key?(asset_path)
    end
  end

  def show_sidebar?
    return false if controller_name == 'sessions'
    return false if controller_name == 'home' && action_name = 'index'
    
    true
  end
end
