class ParseCsvProcess

	def initialize(name)
		@name = name
		@parser = Parser.find_by(name: @name)
		@worksheet ||= GoogleSpreadsheetService.new.worksheet
	end

	def start
		return 'not found' unless @parser
		process
	end

	private

	def process
		csv = CsvParserService.new(path: download_file, encoding: @parser.encoding, col_sep: @parser.col_sep).parse!
		import = @parser.imports.new

		csv.each_with_index do |row, row_num|
			# новый импорт
			# создаём продукт
			product = import.products.new(name: @parser.name, data: row.to_h)
			# находим категории
			Product::CategoryService.new(product, @parser.category_find_target_column_name).categorize!

			# добавляем артикул
			Product::SkuService.new(product, @parser.slug).add_sku!

			# добавляем мета теги
			Product::MetaTagsService.new(product)

			# сртируем перед сохранением
			product.data.sort.to_h

			product.save!
		end

		import.save!

		# headers
		@parser.imports.last.products.first.data.keys.each_with_index do |column, col_num|
			@worksheet[1, col_num + 1] = column
		end

		# body
		@parser.imports.last.products.each_with_index do |product, row_num|
			product.data.values.each_with_index do |column, col_num|
				@worksheet[row_num + 2, col_num + 1] = column
			end
		end

		@worksheet.save

		# @parser.imports.create!(data:  csv.map(&:to_h))
	end

	def download_file
		DownloadFileService.new(options: @parser).download!
	end
end