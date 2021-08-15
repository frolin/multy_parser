class AddProviderToImport < ActiveRecord::Migration[6.1]
  def change
    add_reference :imports, :provider, null: false, foreign_key: true
  end
end
