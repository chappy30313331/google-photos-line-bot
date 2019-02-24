require 'rails_helper'

RSpec.describe Keyword, type: :model do
  it "is valid with a name" do
    keyword = Keyword.new(name: "Test")
    expect(keyword).to be_valid
  end

  it "is invalid without a name" do
    keyword = Keyword.new(name: nil)
    keyword.valid?
    expect(keyword.errors[:name]).to include("can't be blank")
  end

  it "does not allow duplicate names" do
    Keyword.create(name: "Test")
    keyword = Keyword.new(name: "Test")
    keyword.valid?
    expect(keyword.errors[:name]).to include("has already been taken")
  end
end
