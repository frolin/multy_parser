require "down"

class Parsing::Images::Google

	def initialize(products)
		@products = products
	end

	def parse!
		@products.each do |product|

			binding.pry
			Google::Search::Item::Image.new(query => product.name)
			Google::Search::Image.new(:query => product.name).each do |image|
				search = Google::Search::Image.new query: 'foo'

				Down.download(image.uri, destination: "#{Rails.public_path}/providers/#{provider.slug}")
			end
		end
	end
end