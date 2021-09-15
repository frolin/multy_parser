class ImportData::GoogleSpreadsheet
  attr_reader :spreadsheet

		def initialize(gooogle_doc_id)
			@gooogle_doc_id = gooogle_doc_id
			@url = "https://docs.google.com/spreadsheets/d/#{gooogle_doc_id}/export?format=xlsx"
			@spreadsheet = Roo::Spreadsheet.open(@url, extension: :xlsx)
		end

  # def filtered_pages
	# 	spreadsheet.sheets.select { |sheet| sheet.in?(parser.pages)   }
	# end

  # def parse
		# filtered_pages.each do |page|
			# header = spreadsheet.row(parser.start_row)

			# ((parser.start_row + 1)..spreadsheet.last_row).map { |row|
			# 	row = Hash[[header, spreadsheet.row(row)].transpose]
			# 	next if Product.find_by(sku: parser.sku)
				# Product.create!(sku:row[parser.sku], data: row)
			# }
		# end
	# end

end