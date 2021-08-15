class AddSlugToProvider < ActiveRecord::Migration[6.1]
  def change
    add_column :providers, :slug, :string
  end
end
