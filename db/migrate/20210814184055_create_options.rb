class CreateOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :options do |t|
      t.string :name
      t.string :slug
      t.string :sku
      t.jsonb :data
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
