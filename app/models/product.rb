# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  data        :jsonb
#  main        :boolean          default(FALSE), not null
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
	include ProductData

	has_many :import_products
	has_many :imports, through: :import_products
	belongs_to :provider
	has_many :options

	scope :with_options, -> { joins(:options) }
end

