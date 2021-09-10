class AddMainFlagToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :main, :boolean, null: false, default: false
  end
end
