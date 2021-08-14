# == Schema Information
#
# Table name: providers
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Provider < ApplicationRecord
	CONFIG_PATH = "config/parsers.yml"

	has_many :parsers, dependent: :destroy
	has_many :imports
	has_many :products

	def self.init
		parsers = YAML.load_file(CONFIG_PATH)['parsers']
		parsers.each do |parser|
			next if find_by(name: parser[1]['name'])
			provider = new(name: parser[1]['name'], slug: parser[1]['slug'] )
			binding.pry
			provider.parsers.new(parser[1])
			provider.save!
		end
	end

end
