class AddColumMatch < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :guid, :string
    add_column :singles, :guid, :string
    add_column :doubles, :guid, :string
  end
end
