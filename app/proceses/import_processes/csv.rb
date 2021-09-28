module ImportProcesses
	class Csv < ImportProcess
		attr_reader :report

		def initialize(parser:, file_path:)
			super(parser: parser, file_path: file_path)
		end

		def process!
			process

			Rails.logger.info "#{self.class.name} finish."
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

				product.provider = @provider

				product.save!

				@report[:new_products] << product if product.errors.blank?

				import.save
			end

		end
	end
end
