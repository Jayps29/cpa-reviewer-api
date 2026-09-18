class AddUniquePositionToActivities < ActiveRecord::Migration[8.1]
  def change
    add_index :activities, [ :lesson_id, :position ], unique: true
  end
end
