class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.boolean :done, default: false
      t.date :due_on
      t.integer :priority, default: 1

      t.timestamps 
    end
  end
end
