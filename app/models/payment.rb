class Payment < ActiveRecord::Base
  belongs_to :user

  validates :transaction_id, presence: true
  validates :user_id, presence: true
  validates :amount, presence: true
end