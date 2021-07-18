class Product::CategoryService

	CATEGORIES = {
		'специи' => /специ/,
	}.freeze

	DEFAULT_CATEGORY = 'Не найдено'

	def initialize(product, target_column_name)
		@product = product
		@target_column_name = target_column_name
	end

	def categorize!
		categorize
	end

	private

	def categorize
		find_category(@product.data[@target_column_name])
	end

	def find_category(product_column)
		CATEGORIES.each do |name, regexp|
			found_category = name if product_column =~ regexp

			if found_category.present?
				add_category(found_category)
				return
			end

			add_category(DEFAULT_CATEGORY)
		end
	end

	def add_category(category)
		@product.category = category
	end
end