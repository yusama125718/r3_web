class AddColumUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :guid, :string
  end
end
