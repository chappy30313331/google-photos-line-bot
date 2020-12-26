class AddUniqueIndexToTextMessage < ActiveRecord::Migration[6.1]
  def change
    add_index :text_messages, :content, unique: true
  end
end
