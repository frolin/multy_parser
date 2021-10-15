# == Schema Information
#
# Table name: options
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  name       :string
#  sku        :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_options_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class Option < ApplicationRecord
	include ProductData

	belongs_to :product
end
