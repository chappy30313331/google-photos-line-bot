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
          if Keyword.pluck(:name).find { |keyword| event.message['text'].include?(keyword) }
            messages = [
              TextMessage.order("RANDOM()").first.message,
              ImageMessage.new.message
            ]
            @reply_result = client.reply_message(event['replyToken'], messages)
          end
        end
      end
    }

    head @reply_result.nil? ? :ok : @reply_result.code
  end
end