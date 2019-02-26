class ImageMessage < ApplicationRecord
  validates :media_item_id, presence: true
  validates :media_item_id, uniqueness: true

  def fetch
    endpoint = "https://photoslibrary.googleapis.com/v1/mediaItems/"
    uri = URI(endpoint + media_item_id)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    headers = {
      'Authorization'=>'Bearer ' + ENV["GOOGLE_ACCESS_TOKEN"],
      'Content-Type' =>'application/json'
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
