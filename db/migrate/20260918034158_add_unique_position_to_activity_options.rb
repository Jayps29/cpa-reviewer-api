class AddUniquePositionToActivityOptions < ActiveRecord::Migration[8.1]
  def change
    add_index :activity_options, [ :activity_id, :position ], unique: true
  end
end
