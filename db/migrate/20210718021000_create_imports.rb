class CreateImports < ActiveRecord::Migration[6.1]
  def change
    create_table :imports do |t|
      t.string :name
      t.jsonb :data, default: {}
      t.references :importable, polymorphic: true, null: false, index: true

      t.timestamps
    end
  end
end
