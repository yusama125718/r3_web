class Addrule < ActiveRecord::Migration[7.1]
  def change
    add_column :singles, :hopping_allowed, :boolean, null: false, default: false
    add_column :singles, :game_double, :boolean, null: false, default: false
    add_column :singles, :game_ex_speed, :string
    add_column :singles, :game_boundaries, :boolean, null: false, default: false
    add_column :singles, :score_max, :string
    add_column :doubles, :hopping_allowed, :boolean, null: false, default: false
    add_column :doubles, :game_double, :boolean, null: false, default: false
    add_column :doubles, :game_ex_speed, :string
    add_column :doubles, :game_boundaries, :boolean, null: false, default: false
    add_column :doubles, :score_max, :string
  end
end
