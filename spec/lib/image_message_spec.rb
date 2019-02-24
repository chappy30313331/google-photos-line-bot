require 'rails_helper'

RSpec.describe ImageMessage do
  it "returns message hash" do
    image_message = ImageMessage.new
    expected = {
      type: 'image',
      originalContentUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0f/Ruby-logo-notext.png',
      previewImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0f/Ruby-logo-notext.png'
    }
    expect(image_message.message).to eq expected
  end
end
