# frozen_string_literal: true

FactoryBot.define do
  factory :shared_list do
    user { nil }
    list_title { 'MyString' }
  end
end
