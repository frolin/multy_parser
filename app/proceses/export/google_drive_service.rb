module Export
	class GoogleDriveService
		def initialize(parser)
			@session ||= GoogleDrive::Session.from_service_account_key("config/multy-parser-c9349a2f34b0.json")
			@products = Product.by_provider(parser.slug)
			@parser = parser
			@worksheet = worksheet
			@column_names = [
				{ 'НАИМЕНОВАНИЕ' => 'name' },
				{ 'ИЗОБРАЖЕНИЯ' => 'product_image_url' },
				'ОБЪЕМ',
				'ТАРА', 'В КОРОБКЕ',
				'СРОК ГОДНОСТИ',
				'ШТРИХ-КОД',
				'ЦЕНА ОПТ.',
				'вес брутто единицы товара']
		end

		def sync
			puts "spreadsheet sync url: #{@parser.url}"
			save
		end

		def list
			@session.files.each do |file|
				p file.title
			end
		end

		def worksheet
			google_sheet = @session.spreadsheet_by_key(@parser.spreadsheet_sync_url)
			page_number = case @parser.name
			              when 'Polezznoe' then
				              1
			              when 'Афонский сад' then
				              2
			              else
				              0
			              end

			google_sheet.worksheets[page_number]
		end

		def save
			add_headers
			add_products

			@worksheet.save
		end

		def add_headers
			@column_names.each_with_index do |column_name, col_num|
				if column_name.is_a?(Hash)
					@worksheet[1, col_num + 1] = column_name.keys.first # unless sheet[1, col_num + 1] == column
				else
					@worksheet[1, col_num + 1] = column_name
				end
			end
		end

		def add_products
			@products.each_with_index do |product, row_num|
				@column_names.each_with_index do |column_name, col_num|
					if column_name.is_a?(Hash)
						@worksheet[row_num + 2, col_num + 1] = product.send(column_name.values.first) # unless sheet[1, col_num + 1] == column
					else
						@worksheet[row_num + 2, col_num + 1] = product.data[column_name] #unless @worksheet[row_num + 2, col_num + 1] == column
					end
				end

				if product.options.any?
					add_options(product)
				end
			end
		end

		def add_options(product)
			product.options.each_with_index do |option, row_num|
				@column_names.each_with_index do |column_name, col_num|
					if column_name.is_a?(Hash)
						@worksheet[row_num + 2, col_num + 1] = product.send(column_name.values.first) # unless sheet[1, col_num + 1] == column
					else
						@worksheet[row_num + 2, col_num + 1] = product.data[column_name] #unless @worksheet[row_num + 2, col_num + 1] == column
					end
				end
			end
		end
	end
end
