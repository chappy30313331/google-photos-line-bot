class LinebotController < ApplicationController
  require 'line/bot'

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    return head :bad_request unless client.validate_signature(body, signature)

    client.parse_events_from(body).each do |event|
      next unless replyable?(event)

      messages = [TextMessage.sample.message, ImageMessage.sample.message]
      client.reply_message(event['replyToken'], messages)
    end
    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def replyable?(event)
    event.is_a?(Line::Bot::Event::Message) &&
      event.type == Line::Bot::Event::MessageType::Text &&
      contains_keyword?(event.message['text'])
  end

  def contains_keyword?(text)
    @keywords ||= Keyword.pluck(:name)
    @keywords.any? do |keyword|
      text.include?(keyword)
    end
  end
end
