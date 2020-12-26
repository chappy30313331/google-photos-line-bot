namespace :db_maintenance do
  desc 'Refresh image_message table'
  task refresh_image_message: :environment do
    ImageMessage.destroy_all

    ids = FetchImageID.call
    ids.each do |id|
      image_message = ImageMessage.new(media_item_id: id)
      image_message.save!
    end
  end
end
