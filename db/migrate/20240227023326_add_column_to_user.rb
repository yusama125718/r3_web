class AddColumnToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :single_win, :integer
    remove_column :users, :win, :integer
    add_column :users, :single_lose, :integer
    remove_column :users, :lose, :integer
    add_column :users, :double_win, :integer
    add_column :users, :double_lose, :integer
  end
end
