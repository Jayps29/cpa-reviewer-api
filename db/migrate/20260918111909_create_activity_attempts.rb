class CreateActivityAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.text :answer
      t.boolean :correct, null: false

      t.timestamps
    end
  end
end
