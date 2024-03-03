class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.belongs_to :user_info
      t.integer :nw_s_win, default: 0, null:false
      t.integer :nw_s_lose, default: 0, null:false
      t.integer :nw_s_rate, default: 0, null:false
      t.integer :ow_s_win, default: 0, null:false
      t.integer :ow_s_lose, default: 0, null:false
      t.integer :ow_s_rate, default: 0, null:false
      t.integer :nw_d_win, default: 0, null:false
      t.integer :nw_d_lose, default: 0, null:false
      t.integer :nw_d_rate, default: 0, null:false
      t.integer :ow_d_win, default: 0, null:false
      t.integer :ow_d_lose, default: 0, null:false
      t.integer :ow_d_rate, default: 0, null:false
      t.integer :other_win, default: 0, null:false
      t.integer :other_lose, default: 0, null:false
      t.integer :other_rate, default: 0, null:false
      t.belongs_to :season
      t.timestamps
    end

    create_table :user_infos do |t|
      t.string :name, null:false
      t.string :now_name
      t.timestamps
    end

    create_table :matches do |t|
      t.string :guid, null: false
      t.string :redname1 
      t.string :redname2
      t.string :bluename1
      t.string :bluename2
      t.integer :redscore, null: false
      t.integer :bluescore, null: false
      t.string :winner1
      t.string :winner2
      t.string :reddiff1
      t.string :reddiff2
      t.string :bluediff1
      t.string :bluediff2
      t.boolean :is_single, default: false, null: false
      t.boolean :hopping_allowed, default: false, null: false
      t.boolean :game_double, default: false, null: false
      t.boolean :game_boundaries, default: false, null: false
      t.string :game_ex_speed, null: false
      t.string :score_max, null: false
      t.belongs_to :season
      t.timestamps
    end

    create_table :seasons do |t|
      t.string :name, null: false
      t.datetime :finished_at
      t.timestamps
    end
  end
end
