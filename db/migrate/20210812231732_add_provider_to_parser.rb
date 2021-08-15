class AddProviderToParser < ActiveRecord::Migration[6.1]
  def change
    add_reference :parsers, :provider, null: false, foreign_key: true, index: true
  end
end
