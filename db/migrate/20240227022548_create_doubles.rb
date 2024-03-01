class CreateDoubles < ActiveRecord::Migration[7.1]
  def change
    create_table :doubles do |t|
      t.string :redname1
      t.string :redname2
      t.string :bluename1
      t.string :bluename2
      t.datetime :date
      t.integer :redscore
      t.integer :bluescore
      t.string :winner1
      t.string :winner2

      t.timestamps
    end
  end
end
