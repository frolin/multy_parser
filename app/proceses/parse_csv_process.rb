class ParseCsvProcess

	def initialize(name)
		@name = name
		@parser = Parser.find_by(name: @name)
	end

	def start
		return 'not found' unless @parser
		process
	end

	private

	def process
		csv = CsvParserService.new(path: download_file, encoding: @parser.encoding, col_sep: @parser.col_sep).parse!
		csv.each do |row|
			# создаём продукт
			product = @parser.imports.new.products.new(name: @parser.slug, data: row.to_h)
			# находим категории
			Product::CategoryService.new(product, @parser.category_find_target_column_name).categorize!
			# добавляем артикул
			Product::SkuService.new(product)
			# добавляем мета теги
			Product::MetaTagsService.new(product)

			product.save!
		end

		# @parser.imports.create!(data:  csv.map(&:to_h))
	end

	def download_file
		DownloadFileService.new(options: @parser).download!
	end
end