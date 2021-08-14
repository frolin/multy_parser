class AddSkuToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :sku, :string
  end
end
