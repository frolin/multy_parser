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
		return if product_name.blank?

		@url = "https://yandex.ru/images/search?text=#{product_name.squish}&type=clipart&comm=1&isize=large"
		@url.chomp.remove(' &amp;')
	end

	def url_ya(product_name)
		return if product_name.blank?

		@url = "https://yandex.ru/search?text=#{product_name.squish}&type=clipart&comm=1&isize=large"
		@url.chomp.remove(' &amp;')

	end

	def dump_s(keyword)
		image = Parsers::HeadlessBrowser.new(url(keyword), '.url.link.i-bem').find
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
		return if @product.image_url.present?

		image = Parsers::HeadlessBrowser.new(url(keyword), '.MMUnauthPopup-Skip').find
		return unless image.present?

		@product.image_url = image
		@product.save!
		Rails.logger.debug("product save photo! url: #{@product.image_url}")
	end

	def parse_options
		return unless @options.present?

		@options.each do |product_option|
			# next if product_option.image_url.present?

			product_option_image = Parsers::HeadlessBrowser.new(url(product_option.name), '.MMUnauthPopup-Skip').find
			next unless product_option_image.present?

			product_option.image_url = product_option_image
			product_option.save!
			Rails.logger.debug("option save photo! url = #{product_option.image_url}")
		end
	end

	def keyword
		result = ''
		case @product.category.downcase
		when 'разное', 'масло оливковое'
			result = @product.name
		else
			result = with_category
		end

		@product.name.remove(' &amp;')
	end

	def with_category
		([@product.category] + @product.name.split(' ')[0..5]).join(' ')
	end

end