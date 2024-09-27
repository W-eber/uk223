class RenameCreatedDateToDateInDebts < ActiveRecord::Migration[7.0]
  def change
    # Überprüfe zuerst, ob die Spalte existiert, bevor du versuchst, sie umzubenennen
    if column_exists?(:debts, :created_date)
      rename_column :debts, :created_date, :date
    else
      # Falls die Spalte nicht existiert, füge sie hinzu
      add_column :debts, :date, :date
    end
  end
end
