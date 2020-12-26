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
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      refresh_token: ENV['GOOGLE_REFRESH_TOKEN'],
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      grant_type: 'refresh_token'
    )
    options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, options) do |http|
      http.request(request)
    end

    @token = JSON.parse(response.body)['access_token']
  end
end
