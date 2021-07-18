# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
	store_accessor :data, :category, :parser_name, :sku

	has_many :import_products
	has_many :imports, through: :import_products
end
