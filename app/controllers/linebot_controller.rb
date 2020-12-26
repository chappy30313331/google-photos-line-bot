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
    return head :bad_request unless client.validate_signature(body, request.env['HTTP_X_LINE_SIGNATURE'])

    client.parse_events_from(body).each do |event|
      next if !event.is_a?(Line::Bot::Event::Message) || event.type != Line::Bot::Event::MessageType::Text

      @keywords ||= Keyword.pluck(:name)
      next if @keywords.none? { |keyword| event.message['text'].include?(keyword) }

      messages = [TextMessage.order('RANDOM()').first.message, ImageMessage.order('RANDOM()').first.message]
      client.reply_message(event['replyToken'], messages)
    end
    head :ok
  end
end
