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

	def full_page_get_element(url, element)
		# https://medium.com/@khaledhassan45/how-to-scrape-dynamic-content-off-of-a-web-page-using-rails-nokogiri-and-watir-dc6275af1e91

		# @browser ||= Watir::Browser.new
		# @browser.goto(url)
		#
		element =
		binding.pry
		# html = @browser.element(css: /#{element}/).wait_until(&:present?)
		# read_html(html, element)
	end

	def read_html(html, element)
		page = Nokogiri::HTML(html)
		page.search(element).attributes['src'].value
	end

	def url(product_name)
		@url = "https://yandex.ru/images/search?text=#{product_name}&type=clipart&comm=1&isize=large"
	end

	def get_image_url(product_name)
		serp_url =  url(product_name)
		page(serp_url).search('a.serp-item__link')[3].attributes['href'].value
	end

	def parse!

		@products.each do |product|
			image_link = get_image_url(product.name)
			url = 'https://yandex.ru' + image_link
			next if product.product_image_url.present?

			if image_link.present?
				image = Parsers::HeadlessBrowser.go_and_find(url, '.MMImage-Origin')
				next unless image.present?

				product.product_image_url = image
				product.save
			end
			# Down.download(image.uri, destination: "#{Rails.public_path}/providers/#{provider.slug}")
		end
	end
end