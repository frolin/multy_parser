class ProductData::SkuService
	def initialize(product, slug)
		@slug = slug
		@product = product
		@parser = @parser
	end

	def add_sku!
		add_sku
	end

	private

	def add_sku
		@product.sku = "#{@slug.upcase}-#{@product.data['Артикул']}"
	end
end
