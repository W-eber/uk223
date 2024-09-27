class Group < ApplicationRecord
  audited

  # Eine Gruppe hat viele Benutzer durch GroupUsers
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  # Eine Gruppe hat viele Schulden (Debts)
  has_many :debts, dependent: :destroy

  # Validierung für Gruppenname und Gruppencode
  validates :group_name, presence: true
  validates :group_code, presence: true, uniqueness: true
end
