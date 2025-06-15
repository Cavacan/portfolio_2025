# frozen_string_literal: true

require 'httparty'

class LineNotificationService
  include HTTParty
  base_uri 'https://api.line.me'

  def self.notify_user(user, schedules)
    return if schedules.empty?

    message = "本日の予定：\n" + schedules.map do |s|
      date = s.next_notification.strftime('%-m/%-d')
      text = "・#{s.title}（#{date}）"
      text += " ¥#{s.price}" if s.price
      text
    end.join("\n")

    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{ENV.fetch('LINE_CHANNEL_ACCESS_TOKEN', nil)}"
    }

    body = {
      to: user.line_user_id,
      messages: [
        {
          type: 'text',
          text: message
        }
      ]
    }

    post('/v2/bot/message/push', headers: headers, body: body.to_json)
  end
end
