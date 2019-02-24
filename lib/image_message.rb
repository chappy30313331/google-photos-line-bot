class ImageMessage
  def initialize
    @image_url = 'https://upload.wikimedia.org/wikipedia/commons/0/0f/Ruby-logo-notext.png'
  end

  def message
    {
      type: 'image',
      originalContentUrl: @image_url,
      previewImageUrl: @image_url
    }
  end
end