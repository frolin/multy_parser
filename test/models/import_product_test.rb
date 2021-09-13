# == Schema Information
#
# Table name: import_products
#
#  id         :bigint           not null, primary key
#  page_name  :string
#  row_number :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  import_id  :bigint           not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_import_products_on_import_id   (import_id)
#  index_import_products_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (import_id => imports.id)
#  fk_rails_...  (product_id => products.id)
#
require "test_helper"

class ImportProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
