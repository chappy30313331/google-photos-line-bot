require 'rails_helper'

RSpec.describe ImageMessage, type: :model do
  it "is valid with a media item id" do
    image_message = ImageMessage.new(media_item_id: "Test")
    expect(image_message).to be_valid
  end

  it "is invalid without a media item id" do
    image_message = ImageMessage.new(media_item_id: nil)
    image_message.valid?
    expect(image_message.errors[:media_item_id]).to include("can't be blank")
  end

  it "does not allow duplicate media item ids" do
    ImageMessage.create(media_item_id: "Test")
    image_message = ImageMessage.new(media_item_id: "Test")
    image_message.valid?
    expect(image_message.errors[:media_item_id]).to include("has already been taken")
  end

  it "returns message hash" do
    image_message = ImageMessage.new(media_item_id: "Test")
    image_message.instance_variable_set('@json', {"baseUrl" => "https://lh3.googleusercontent.com/lr/test"})
    message = image_message.message
    expect(message[:type]).to eq "image"
    expect(message[:originalContentUrl]).to match(/https:\/\/lh3\.googleusercontent\.com\/lr\/.*/)
    expect(message[:previewImageUrl]).to match(/https:\/\/lh3\.googleusercontent\.com\/lr\/.*/)
  end
end
