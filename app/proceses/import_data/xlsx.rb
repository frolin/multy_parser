class ImportData::Xlsx
	# attr_reader :spreadsheet, :parser, :current_row
	#
	def initialize(config:, spreadsheet:)
		@config = config
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
			  product_map: find_range(page)
			}
		end
	end

	def filtered_pages
		@spreadsheet.sheets.select { |sheet| sheet.in?(@config.pages) }
	end

	def find_range(page)
		ImportData::Xlsx::FindRange.new(config: @config, spreadsheet: @spreadsheet, page: page).process!
	end

	def parse_all(ranges)
		ranges.each do |range|
			puts "Parse #{range[:page_name]}"
			ImportData::Xlsx::ParseRange.new(config: @config, spreadsheet: @spreadsheet, range: range).process!
		end
	end
end