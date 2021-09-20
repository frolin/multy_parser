module ImportProcesses
	class Xlsx
		# attr_reader :spreadsheet, :parser, :current_row
		#
		def initialize(parser:, spreadsheet:)
			@parser = parser
			@spreadsheet = spreadsheet
		end

		def process!
			ranges = find_ranges(filtered_pages)
			parse_all(ranges)
		end

		private

		def find_ranges(pages)
			pages.map do |page|
				{ page_name: page,
				  product_map: find_range(page) }
			end
		end

		def filtered_pages
			@spreadsheet.sheets.select { |sheet| sheet.in?(@parser.pages) }
		end

		def find_range(page)
			ImportProcesses::Xlsx::FindRange.new(parser: @parser, spreadsheet: @spreadsheet, page: page).process!
		end

		def parse_all(ranges)
			ranges.each do |range|
				ImportProcesses::Xlsx::ParseRange.new(parser: @parser, spreadsheet: @spreadsheet, range: range).process!
			end
		end
	end
end
