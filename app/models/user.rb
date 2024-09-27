class User < ApplicationRecord
  audited
  has_secure_password

  # Eine User hat viele Gruppen über GroupUsers
  has_many :group_users
  has_many :groups, through: :group_users

  # Schulden-Relationen
  has_many :debts_as_payer, class_name: 'Debt', foreign_key: 'payer_id'
  has_many :debts_as_payee, class_name: 'Debt', foreign_key: 'payee_id'

  # Validierung für den Benutzernamen und E-Mail
  validates :username, presence: true, 
                       uniqueness: { case_sensitive: false }, 
                       length: { maximum: 16 }, 
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 12 }, if: -> { new_record? || !password.nil? }

  # Vor dem Speichern wird der Benutzername in Kleinbuchstaben umgewandelt
  before_save :downcase_username

  private

  def downcase_username
    self.username = username.downcase
  end
end
