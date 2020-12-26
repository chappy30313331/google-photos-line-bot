class LinebotController < ApplicationController
  require 'line/bot'

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    head :bad_request unless client.validate_signature(body, signature)

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if Keyword.pluck(:name).find { |keyword| event.message['text'].include?(keyword) }
            messages = [
              TextMessage.order('RANDOM()').first.message,
              ImageMessage.order('RANDOM()').first.message
            ]
            @reply_result = client.reply_message(event['replyToken'], messages)
          end
        end
      end
    end

    head @reply_result.nil? ? :ok : @reply_result.code
  end
end
