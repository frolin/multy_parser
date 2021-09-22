module ImportProcesses
	class Xlsx
		# attr_reader :spreadsheet, :parser, :current_row
		#
		def initialize(parser:, file_path:)
			@parser = parser
			@spreadsheet = Roo::Spreadsheet.open(file_path)
			@range = {}
		end

		def process!
			Rails.logger.info "start import process #{@parser.name}"

			find_ranges
			parse_all
		end

		private

		def find_ranges
			filtered_pages.each do |page|
				@range[page] = find_range(page)
			end
		end

		def filtered_pages
			@filtered_pages ||= @spreadsheet.sheets.select { |sheet| sheet.in?(@parser.pages) }
		end

		def find_range(page)
			ImportProcesses::Xlsx::FindRange.new(parser: @parser, spreadsheet: @spreadsheet, page: page).process!
		end

		def parse_all
			@range.each do |page_name, range|
				Rails.logger.info("Parsing products page: #{page_name}")

				ImportProcesses::Xlsx::ParseRange.new(parser: @parser, spreadsheet: @spreadsheet, page: page_name, range: range).process!
			end
		end
	end
end
