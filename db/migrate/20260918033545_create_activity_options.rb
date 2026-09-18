class CreateActivityOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_options do |t|
      t.references :activity, null: false, foreign_key: true
      t.text :text, null: false
      t.integer :position, null: false
      t.boolean :is_correct, null: false, default: false

      t.timestamps
    end
  end
end
