class RemoveColum < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :create_at, :datetime
    remove_column :users, :update_at, :datetime
    remove_column :singles, :date, :datetime
    remove_column :doubles, :date, :datetime
  end
end
