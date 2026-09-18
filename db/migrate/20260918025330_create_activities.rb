class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.references :lesson, null: false, foreign_key: true
      t.string :activity_type, null: false
      t.string :title
      t.text :prompt
      t.text :explanation
      t.integer :position, null: false

      t.timestamps
    end
  end
end
