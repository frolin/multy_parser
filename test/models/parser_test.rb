# == Schema Information
#
# Table name: parsers
#
#  id          :bigint           not null, primary key
#  name        :string
#  settings    :jsonb
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  provider_id :bigint           not null
#
# Indexes
#
#  index_parsers_on_provider_id  (provider_id)
#
# Foreign Keys
#
#  fk_rails_...  (provider_id => providers.id)
#
require "test_helper"

class ParserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
