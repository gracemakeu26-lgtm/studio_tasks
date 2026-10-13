class Task < ApplicationRecord
    belongs_to :user, optional: true

    scope :open_tasks, -> { where(done: false) }
    scope :overdue, -> { open_tasks.where("due_on < ?", Date.today) }
    scope :unassigned, -> { where(user_id: nil) }

    validates :title, presence: true, length: { maximum: 120 }
    validates :priority, inclusion: { in: [0, 1, 2] }
    validates :description, length: { maximum: 500 }
end
