# frozen_string_literal: true

FactoryBot.define do
  factory :shared_user do
    host_user { nil }
    shared_list { nil }
    email { 'MyString' }
    initial_password_digest { 'MyString' }
    status { 1 }
    named_by_shared_user { 'MyString' }
    named_by_host_user { 'MyString' }
    magic_link_token { 'MyString' }
    magic_link_token_end_time { '2025-04-19 18:25:06' }
    old_magic_link_token { 'MyString' }
    old_magic_link_token_end_time { '2025-04-19 18:25:06' }
  end
end
