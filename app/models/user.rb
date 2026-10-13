class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :tasks, dependent: :nullify

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :role, inclusion: { in: %w[manager esthetician receptionist] }
  validates :name, presence: true
end
