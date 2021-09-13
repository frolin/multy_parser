class AddRowNumberToImportProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :import_products, :row_number, :integer
  end
end
