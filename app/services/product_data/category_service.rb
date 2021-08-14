class ProductData::CategoryService

	NO_FOUND_CATEGORY = 'Не найдено'

	def initialize(product,  parser)
		@product = product
		@parser = parser
		@target_column_names = @parser.target_column_names
	end



	private


end