# == Schema Information
#
# Table name: parsers
#
#  id         :bigint           not null, primary key
#  name       :string
#  settings   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class ParserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
