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
require "test_helper"

class ImportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
