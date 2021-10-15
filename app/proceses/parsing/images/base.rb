require "down"

class Parsing::Images::Base

	def initialize(agent: Mechanize.new, parser:, products:)
		@agent = agent
		@parser = parser
		@products = products.includes(:options)
		@category_list = []
	end

	def page(url)
		@agent.get(url)
	end

	def url(product_name)
		@url = "https://yandex.ru/images/search?text='#{product_name.chomp}'&type=clipart&comm=1&isize=large"
	end

	def parse!
		@products.each do |product|
			@product = product
			@options = product.options
			# Rails.logger.debug('Product', product: product)

			parse_products
			parse_options

			# Down.download(image.uri, destination: "#{Rails.public_path}/providers/#{provider.slug}")
		end
	end

	def parse_products
		# return if @product.product_image_url.present?

		image = Parsers::HeadlessBrowser.new(url(@product.name), '.MMUnauthPopup-Skip').find
		return unless image.present?

		@product.product_image_url = image
		@product.save!
		Rails.logger.debug('product save photo!')
	end

	def parse_options
		return unless @options.present?

		@options.each do |product_option|
			product_option_image = Parsers::HeadlessBrowser.new(url(product_option.name), '.MMUnauthPopup-Skip').find
			next unless product_option_image.present?

			product_option.product_image_url = product_option_image
			product_option.save!
			Rails.logger.debug('option save photo!')
		end
	end

end