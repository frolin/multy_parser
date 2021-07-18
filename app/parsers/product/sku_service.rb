class Product::SkuService
	def initialize(product, slug)
		@slug = slug
		@product = product
	end

	def add_sku!
		add_sku
	end

	private

	def add_sku
		@product.sku = "#{@slug.upcase}-#{@product.data['Артикул']}"
	end

end