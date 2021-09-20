class ImportProducts
	def initialize(parser:)
		@parser = parser
	end

	def import
		case @parser.parse_type
		when 'xlsx'
			spreadsheet = ImportService::GoogleSpreadsheet.new(@parser.google_doc_id).spreadsheet
			ImportProcesses::Xlsx.new(parser: @parser, spreadsheet: spreadsheet).process!
			Export::GoogleDriveService.new(@parser).sync
		when 'csv'
			ImportProcesses::Csv.new(parser: @parser).process!
			Export::GoogleDriveService.new(@parser).sync

		else
			return
		end
	end
end