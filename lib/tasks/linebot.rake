namespace :linebot do
  desc 'Push text and image messages to a user'
  task push_message: :environment do
    client = Line::Bot::Client.new do |config|
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
    messages = [
      TextMessage.order('RANDOM()').first.message,
      ImageMessage.order('RANDOM()').first.message
    ]
    client.push_message(ENV['USER_ID_TO_PUSH'], messages)
  end
end
