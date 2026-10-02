class Task < ApplicationRecord
    validates :title, presence: true, length: { maximum: 120 }
    validates :priority, inclusion: { in: [0, 1, 2] }
    validates :description, length: { maximum: 500 }
end
