module Export

	class GoogleDriveService
		def initialize(parser)
			@session ||= GoogleDrive::Session.from_service_account_key("config/multy-parser-c9349a2f34b0.json")
			@products = Product.last(10) # where(provider: parser.provider)
			@parser = parser
		end

		def sync
			puts "spreadsheet sync url: "
			save
		end

		def list
			@session.files.each do |file|
				p file.title
			end
		end

		def worksheet(page_name = nil)
			google_sheet = @session.spreadsheet_by_key(@parser.spreadsheet_sync_url)

			case page_name
			when 'Polezznoe'
				@worksheet = google_sheet.worksheets[1]
			when 'Афонский сад'
				@worksheet = google_sheet.worksheets[2]
			else
				@worksheet = google_sheet.worksheets[2]
			end

		end

		def save
			add_headers
			add_rows

			worksheet.save
		end


		def add_headers
			@products.first.data.keys.each_with_index do |column, col_num|
				worksheet[1, col_num + 1] = column # unless sheet[1, col_num + 1] == column
			end
		end

		def add_rows
			@products.each_with_index do |product, row_num|
				product.data.values.each_with_index do |column, col_num|
					worksheet[row_num + 2, col_num + 1] = column unless worksheet[row_num + 2, col_num + 1] == column
				end
			end
		end
	end
end