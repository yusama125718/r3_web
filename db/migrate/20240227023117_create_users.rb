class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.datetime :create_at
      t.datetime :update_at
      t.integer :win
      t.integer :lose

      t.timestamps
    end
  end
end
