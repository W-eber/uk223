class GroupUser < ApplicationRecord
  audited
  belongs_to :group
  belongs_to :user

  # Define roles with ActiveRecord Enum
  enum role: { member: 0, moderator: 1, admin: 2 }

  validates :role, inclusion: { in: roles.keys }
end
