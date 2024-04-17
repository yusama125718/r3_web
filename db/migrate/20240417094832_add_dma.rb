class AddDma < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :dma_win, :integer, default: 0, null:false
    add_column :users, :dma_lose, :integer, default: 0, null:false
    add_column :users, :dma_rate, :integer, default: 0, null:false

    add_column :matches, :dma, :boolean, default: false, null:false
  end
end
