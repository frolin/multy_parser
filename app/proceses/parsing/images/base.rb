require "down"

class Parsing::Images::Base

	def initialize(agent: Mechanize.new, parser:)
		@agent = agent
		@parser = parser
		@products = Product.by_provider(parser.provider.slug)
		@category_list = []
	end

	def page(url)
		# https://medium.com/@khaledhassan45/how-to-scrape-dynamic-content-off-of-a-web-page-using-rails-nokogiri-and-watir-dc6275af1e91
		# @browser ||= Watir::Browser.new
		# @browser.go_to
		@agent.get(url)
	end

	def url(product_name)
		@url = "https://yandex.ru/images/search?text=#{product_name}type=clipart&isize=large"
	end

	def get_image_url(product_name)
		page(url(product_name))
	end

	def parse!

		@products.each do |product|
			page = get_image_url(product.name)
			image_url = page.search('.serp-item__link > img')[3].attributes['src'].value

			next if product.product_image_url.present?

			if image_url.present?
				product.product_image_url = image_url.gsub('//', 'http://')
				product.save
			end

			sleep 3
			# Down.download(image.uri, destination: "#{Rails.public_path}/providers/#{provider.slug}")
		end
	end
end