class LinebotController < ApplicationController
  require 'line/bot'

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if keywords.find { |keyword| event.message['text'].include?(keyword) }
            @reply_result = client.reply_message(event['replyToken'], messages)
          end
        end
      end
    }

    head @reply_result.nil? ? :bad_request : @reply_result.code
  end

  def keywords
    ["きーわーど", "キーワード"]
  end

  def messages
    [
      {
        type: 'text',
        text: "text"
      },
      {
        type: 'image',
        originalContentUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0f/Ruby-logo-notext.png',
        previewImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0f/Ruby-logo-notext.png'
      }
    ]
  end
end