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
require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
