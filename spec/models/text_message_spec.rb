require 'rails_helper'

RSpec.describe TextMessage, type: :model do
  it "is valid with a content" do
    text_message = TextMessage.new(content: "Test")
    expect(text_message).to be_valid
  end

  it "is invalid without a content" do
    text_message = TextMessage.new(content: nil)
    text_message.valid?
    expect(text_message.errors[:content]).to include("can't be blank")
  end

  it "does not allow duplicate contents" do
    TextMessage.create(content: "Test")
    text_message = TextMessage.new(content: "Test")
    text_message.valid?
    expect(text_message.errors[:content]).to include("has already been taken")
  end

  it "returns message hash" do
    text_message = TextMessage.create(content: "Test")
    expected = {
      type: "text",
      text: "Test"
    }
    expect(text_message.message).to eq expected
  end
end
