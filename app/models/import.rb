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
#
# Indexes
#
#  index_imports_on_importable  (importable_type,importable_id)
#
class Import < ApplicationRecord
  belongs_to :importable, polymorphic: true

	has_many :import_products
	has_many :products, through: :import_products


	private

	def categorize
		binding.pry
		data
	end

end