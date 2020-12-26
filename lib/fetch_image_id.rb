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
    headers = { 'Content-Type' => 'application/json' }
    params = { album_id: ENV['ALBUM_ID'] }
    params[:pageToken] = next_page_token if next_page_token

    response = HTTP.auth("Bearer #{AccessToken.instance}")
                   .post(uri, headers: headers, json: params)
    JSON.parse(response.body.to_s)
  end
end
