# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  data        :jsonb
#  name        :string
#  sku         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  provider_id :bigint           not null
#
# Indexes
#
#  index_products_on_provider_id  (provider_id)
#
# Foreign Keys
#
#  fk_rails_...  (provider_id => providers.id)
#
class Product < ApplicationRecord
	store_accessor :data, :category, :parser_name, :sku

	has_many :import_products
	has_many :imports, through: :import_products
	has_many :options
	belongs_to :provider
	has_many :options

	validates :sku, presence: true

	def self.exists?(value)
		return true if self.where('data @> ?', {'Артикул': value}.to_json).exists?
	end

end
