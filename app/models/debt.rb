class Debt < ApplicationRecord
  audited
  belongs_to :payer, class_name: 'User', foreign_key: 'payer_id'
  belongs_to :payee, class_name: 'User', foreign_key: 'payee_id'
  belongs_to :group

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
  validates :is_paid, inclusion: { in: [true, false] }

  before_validation :set_default_is_paid, on: :create

  private

  def set_default_is_paid
    self.is_paid = false if is_paid.nil?
  end
end
