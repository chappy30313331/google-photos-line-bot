class AddUniqueIndexToKeyword < ActiveRecord::Migration[6.1]
  def change
    add_index :keywords, :name, unique: true
  end
end
