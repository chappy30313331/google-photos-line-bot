require 'singleton'

class AccessToken
  include Singleton

  def initialize
    refresh
  end

  def to_s
    @token
  end

  private

  def refresh
    uri = URI.parse('https://www.googleapis.com/oauth2/v4/token')
    params = {
      refresh_token: ENV['GOOGLE_REFRESH_TOKEN'],
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      grant_type: 'refresh_token'
    }

    response = HTTP.post(uri, form: params)
    @token = JSON.parse(response.body.to_s).fetch('access_token')
  end
end
