class CreateParsers < ActiveRecord::Migration[6.1]
  def change
    create_table :parsers do |t|
      t.string :name
      t.jsonb :settings, default: {}

      t.timestamps
    end
  end
end
