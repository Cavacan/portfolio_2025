# frozen_string_literal: true

module ApplicationHelper
  def asset_exists?(asset_path)
    if Rails.application.config.assets.compile
      Rails.application.assets&.find_asset(asset_path).present?
    else
      Rails.application.assets_manifest.files.key?(asset_path)
    end
  end

  def admin_namespace?
    controller_path.start_with?('admin/')
  end

  def show_sidebar?
    return false if controller_name == 'sessions'
    return false if controller_name == 'registrations'
    return false if controller_name == 'password_resets'
    return false if controller_name == 'magic_links'
    return false if controller_name == 'home' && 'index'

    true
  end

  def sidebar_class
    return unless show_sidebar?

    admin_namespace? ? 'with-admin-sidebar' : 'with-sidebar'
  end
end
