class CreateSingles < ActiveRecord::Migration[7.1]
  def change
    create_table :singles do |t|
      t.string :redname
      t.string :bluename
      t.datetime :date
      t.integer :redscore
      t.integer :bluescore
      t.string :winner

      t.timestamps
    end
  end
end
