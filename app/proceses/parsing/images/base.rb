require "down"

class Parsing::Images::Base

	def initialize(agent: Mechanize.new, parser:)
		@agent = agent
		@parser = parser
		@products = Product.by_provider(parser.provider.slug)
		@category_list = []
	end

	def page(url)
		@agent.get(url)
	end

	def read_html(html, element)
		page = Nokogiri::HTML(html)
		page.search(element).attributes['src'].value
	end

	def url(product_name)
		@url = "https://yandex.ru/images/search?text='#{product_name.chomp}'&type=clipart&comm=1&isize=large"
	end

	def parse!
		@products.each do |product|
			next if product.product_image_url.present?

			image = Parsers::HeadlessBrowser.new(url(product.name), '.MMImage-Origin').find
			next unless image.present?

			product.product_image_url = image
			product.save

			# Down.download(image.uri, destination: "#{Rails.public_path}/providers/#{provider.slug}")
		end
	end
end