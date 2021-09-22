module ImportProcesses
	class Csv
		def initialize(parser:, file_path:)
			@parser = parser
			@file_path = file_path
			@new_products = []
		end

		def process!
			process
		end

		private

		def process
			csv = Parsers::CsvParser.new(path: @file_path, encoding: @parser.encoding, col_sep: @parser.col_sep).parse!

			# новый импорт
			import = @parser.imports.new(provider: @parser.provider)

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

				@new_products << product if product.errors.blank?

				import.save!
			end

			Rails.logger.info "#{self.class.name} end process"
			Rails.logger.info "New products added: #{@new_products.size}"
		end
	end
end
