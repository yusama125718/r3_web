class AddColumToSeason < ActiveRecord::Migration[7.1]
  def change
    add_column :seasons, :message, :string
  end
end
