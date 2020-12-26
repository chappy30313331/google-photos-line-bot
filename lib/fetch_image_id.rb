class FetchImageID
  def self.call
    ids = []

    body = fetch
    loop do
      body['mediaItems'].each do |item|
        ids << item['id']
      end
      break if body['nextPageToken'].nil?

      body = fetch(next_page_token: body['nextPageToken'])
    end

    ids
  end

  def self.fetch(next_page_token: nil)
    uri = URI.parse('https://photoslibrary.googleapis.com/v1/mediaItems:search')
    headers = {
      'Authorization' => "Bearer #{AccessToken.instance}",
      'Content-Type' => 'application/json'
    }
    request = Net::HTTP::Post.new(uri, headers)

    body = { albumId: ENV['ALBUM_ID'] }
    body[:pageToken] = next_page_token unless next_page_token.nil?
    request.set_form_data(body)

    options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, options) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end
