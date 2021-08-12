module ImportData

	class GoogleSpreadsheet

		def initialize(gooogle_doc_id)
			@gooogle_doc_id = gooogle_doc_id
			@url = "https://docs.google.com/spreadsheets/d/#{gooogle_doc_id}/export?format=xlsx"
			@sheet = Roo::Spreadsheet.open(@url, extension: :xlsx)
		end

	end

end