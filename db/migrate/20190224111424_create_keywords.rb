class CreateKeywords < ActiveRecord::Migration[5.2]
  def change
    create_table :keywords do |t|
      t.string :name, null: false, unique: true

      t.timestamps
    end
  end
end
