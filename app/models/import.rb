# == Schema Information
#
# Table name: imports
#
#  id              :bigint           not null, primary key
#  data            :jsonb
#  importable_type :string           not null
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  importable_id   :bigint           not null
#  provider_id     :bigint           not null
#
# Indexes
#
#  index_imports_on_importable   (importable_type,importable_id)
#  index_imports_on_provider_id  (provider_id)
#
# Foreign Keys
#
#  fk_rails_...  (provider_id => providers.id)
#
class Import < ApplicationRecord
  belongs_to :importable, polymorphic: true

	has_many :import_products
	has_many :products, through: :import_products
	belongs_to :provider

	private

	def categorize
		data
	end

end
