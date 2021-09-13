class AddPageNameToImportProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :import_products, :page_name, :string
  end
end
