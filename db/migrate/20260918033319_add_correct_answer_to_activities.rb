class AddCorrectAnswerToActivities < ActiveRecord::Migration[8.1]
  def change
    add_column :activities, :correct_answer, :text
  end
end
