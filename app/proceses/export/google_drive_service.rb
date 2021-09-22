module Export
	class GoogleDriveService
		def initialize(parser)
			@session ||= GoogleDrive::Session.from_service_account_key("config/multy-parser-c9349a2f34b0.json")
			@products = Product.by_provider(parser.slug)
			@parser = parser
			@worksheet = worksheet
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
			              when 'Polezznoe' then 1
			              when 'Афонский сад' then 2
			              else 0
			              end

			google_sheet.worksheets[page_number]
		end

		def save
			add_headers
			add_products

			@worksheet.save
		end

		def add_headers
			@products.first.data.keys.each_with_index do |column, col_num|
				@worksheet[1, col_num + 1] = column # unless sheet[1, col_num + 1] == column
			end
		end

		def add_products
			@products.each_with_index do |product, row_num|
				product.data.values.each_with_index do |column, col_num|
					@worksheet[row_num + 2, col_num + 1] = column unless @worksheet[row_num + 2, col_num + 1] == column
				end

				if product.options.any?
					add_options(product)
				end
			end
		end

		def add_options(product)
			product.options.each_with_index do |option, row_num|
				option.data.values.each_with_index do |column, col_num|
					@worksheet[row_num + 2, col_num + 1] = column unless @worksheet[row_num + 2, col_num + 1] == column
				end
			end
		end
	end
end
