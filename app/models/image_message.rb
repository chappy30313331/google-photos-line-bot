class ImageMessage < ApplicationRecord
  validates :media_item_id, presence: true
  validates :media_item_id, uniqueness: true

  def fetch
    uri = URI("https://photoslibrary.googleapis.com/v1/mediaItems/#{media_item_id}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    headers = {
      'Authorization'=>"Bearer #{AccessToken.instance.to_s}",
      'Content-Type' =>"application/json"
    }
    response = http.get(uri.path, headers)
    @json = JSON.parse(response.body)
  end

  def message
    if @json.nil?
      fetch
    end

    {
      type: "image",
      originalContentUrl: @json["baseUrl"],
      previewImageUrl: @json["baseUrl"]
    }
  end
end
