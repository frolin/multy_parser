class ProductData::CategoryService

	CATEGORIES = {
		'специи' => /специ/,
		'Суперфуды' => /Суперфуд/,
	}.freeze
	NO_FOUND_CATEGORY = 'Не найдено'

	DEFAULT_CATEGORY = 'Не найдено'

	def initialize(product,  parser)
		@product = product
		@parser = parser
		@target_column_names = @parser.category_find_target_column_name
	end

	def categorize!
		categorize
	end


	private

	def categorize
		find_category
		add_category
	end

	def find_category
		@found_category = {}

		CATEGORIES.each do |name, regexp|
			@target_column_names.each do |column_name|
				if @product.data[column_name] =~ regexp
					@found_category[name] = [column_name, true]
				end
			end
		end
	end

	def add_category
		return false if @product.category.present?

		if @found_category.present?
			@product.category = @found_category.keys.join(', ')
			return true
		end

		@product.category = DEFAULT_CATEGORY
	end
end
