class AddOwner < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :owner, :string
  end
end
