class AddSlugToParser < ActiveRecord::Migration[6.1]
  def change
    add_column :parsers, :slug, :string
  end
end
