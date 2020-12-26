class AddUniqueIndexToImageMessage < ActiveRecord::Migration[6.1]
  def change
    add_index :image_messages, :media_item_id, unique: true
  end
end
