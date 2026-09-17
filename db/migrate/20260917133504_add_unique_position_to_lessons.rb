class AddUniquePositionToLessons < ActiveRecord::Migration[8.1]
  def change
    add_index :lessons, [ :topic_id, :position ], unique: true
  end
end
