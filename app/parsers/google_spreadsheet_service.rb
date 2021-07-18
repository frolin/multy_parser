class GoogleSpreadsheetService
	def initialize
		@session ||= GoogleDrive::Session.from_service_account_key("multy-parser-c9349a2f34b0.json")
	end

	def list
		@session.files.each do |file|
			p file.title
		end
	end

	def worksheet
		@worksheet ||= @session.spreadsheet_by_key("1_DhZvlzwlviXWVgksClNF1cNUl-F8e_Z9_-LjY0P-AU").worksheets[0]
	end

	def insert_rows(row, rows)
		spreadsheet.insert_rows(row, rows)
	end

end