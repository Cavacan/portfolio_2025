# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'rspec_test@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
  end

  factory :admin_user, class: 'User' do
    email { 'rspec_admin@example.com' }
    password { 'adminpass' }
    password_confirmation { 'adminpass' }
    admin { true }
  end
end
