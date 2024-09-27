class AddRoleToGroupsUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :groups_users, :role, :integer, default: 0
  end
end
