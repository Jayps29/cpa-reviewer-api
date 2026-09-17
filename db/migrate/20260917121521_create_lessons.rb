class CreateLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :lessons do |t|
      t.references :topic, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :position, null: false

      t.timestamps
    end
  end
end
