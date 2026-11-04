class AddUniqueIndexToTasks < ActiveRecord::Migration[8.1]
  def change
    add_index :tasks, [:title, :description, :due_on, :priority, :done, :user_id], unique: true, name: 'idx_tasks_uniqueness_group'
  end
end
