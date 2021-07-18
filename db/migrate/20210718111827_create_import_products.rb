class CreateImportProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :import_products do |t|
      t.references :import, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
