require 'rails_helper'
require 'rake'

describe 'db_maintenance' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require('db_maintenance', ["#{Rails.root}/lib/tasks"])
    Rake::Task.define_task(:environment)
  end

  describe 'refresh_image_message' do
    it 'refreshes successfully' do
      image_message = ImageMessage.create(media_item_id: "Test")
      @rake['db_maintenance:refresh_image_message'].execute

      expect(ImageMessage.find_by(media_item_id: "Test")).to be nil
      expect(ImageMessage.count).to be > 0
    end
  end
end