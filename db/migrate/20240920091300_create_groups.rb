class CreateGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :groups do |t|
      t.string :group_code
      t.string :group_name

      t.timestamps
    end
  end
end
