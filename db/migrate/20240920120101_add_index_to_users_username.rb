class AddIndexToUsersUsername < ActiveRecord::Migration[7.0]
  def change
    add_index :users, "LOWER(username)", unique: true  # Case-insensitive Index
  end
end
