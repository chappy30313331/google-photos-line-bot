class CreateTextMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :text_messages do |t|
      t.string :content

      t.timestamps
    end
  end
end
