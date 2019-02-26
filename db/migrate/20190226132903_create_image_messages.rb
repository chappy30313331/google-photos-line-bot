class CreateImageMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :image_messages do |t|
      t.string :media_item_id

      t.timestamps
    end
  end
end
