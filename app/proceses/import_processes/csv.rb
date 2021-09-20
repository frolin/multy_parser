module ImportProcesses
	class Csv
		def initialize(parser:)
			@parser = parser
		end

		def process!
			process
		end

		private

		def process
			csv = Parsers::CsvParser.new(path: download_file, encoding: @parser.encoding, col_sep: @parser.col_sep).parse!

			# новый импорт
			import = @parser.imports.new(provider_id: @parser.provider.id)

			csv.each_with_index do |row, row_num|
				# Если продукт уже есть
				next if Product.exists?(row.to_h['Артикул'])

				# создаём продукт
				product = import.products.new(name: @parser.name, data: row.to_h)

				# находим категории
				ProductData::CategoryService.new(product, @parser).categorize!

				# добавляем артикул
				ProductData::SkuService.new(product, @parser.slug).add_sku!

				# добавляем мета теги
				ProductData::MetaTagsService.new(product)

				# сртируем перед сохранением
				product.data.sort.to_h

				product.provider = @parser.provider

				product.save!
			end

			import.save!

			puts "#{self.class.name} end process"
		end

		def download_file
			ImportService::DownloadFile.new(parser: @parser).download!
		end
	end
end
