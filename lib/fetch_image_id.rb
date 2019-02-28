class FetchImageID

  def self.call
    results = fetch
    
    loop do
      results["mediaItems"].each do |item|
        image_message = ImageMessage.new(media_item_id: item["id"])
        image_message.save!
      end
      break if results["nextPageToken"].nil?
      results = fetch(next_page_token: results["nextPageToken"])
    end
  end

  private

  def self.fetch(next_page_token: nil)
    uri = URI.parse("https://photoslibrary.googleapis.com/v1/mediaItems:search")
    headers = {
      'Authorization'=>"Bearer #{AccessToken.instance.to_s}",
      'Content-Type' =>"application/json"
    }
    request = Net::HTTP::Post.new(uri, headers)

    body = { albumId: ENV["ALBUM_ID"] }
    body[:pageToken] = next_page_token unless next_page_token.nil?
    request.set_form_data(body)

    options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, options) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end
end