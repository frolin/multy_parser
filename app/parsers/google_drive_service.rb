class GoogleDriveService
	def initialize(products = Product.all, parser)
		@session ||= GoogleDrive::Session.from_service_account_key("config/multy-parser-c9349a2f34b0.json")
		@products = products
		@parser = parser
	end

	def sync
		spreadsheet
	end

	def list
		@session.files.each do |file|
			p file.title
		end
	end

	def worksheet
		@worksheet ||= @session.spreadsheet_by_key(@parser.spreadsheet_sync_url).worksheets[0]
	end

	def spreadsheet
		headers
		rows

		worksheet.save
	end

	def headers
		@products.first.data.keys.each_with_index do |column, col_num|
			worksheet[1, col_num + 1] = column
		end
	end

	def rows
		@products.each_with_index do |product, row_num|
			product.data.values.each_with_index do |column, col_num|
				worksheet[row_num + 2, col_num + 1] = column
			end
		end
	end
end