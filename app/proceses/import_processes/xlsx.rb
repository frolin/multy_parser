module ImportProcesses
	class Xlsx < ImportProcess
		attr_reader :report

		def initialize(parser:, file_path:)
			super(parser: parser, file_path: file_path)
			@header = parser.header_map
			@sku_name = parser.header_map[parser.sku_column.to_s]
			@spreadsheet = Roo::Spreadsheet.open(file_path)
		end

		def process!
			find_ranges
			parse_ranges

			Rails.logger.info "#{self.class.name} finish."
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

		def parse_ranges
			@range.each do |page_name, range|
				Rails.logger.info "#{page_name} Parse range."

				parse_range = ImportProcesses::Xlsx::ParseRange.new(parser: @parser, spreadsheet: @spreadsheet, page: page_name, range: range)
				parse_range.process!
				@report = parse_range.report

				Rails.logger.info("New products count: #{@report[:new_products].size + @report[:new_options].size}")
				Rails.logger.info("Found products count: #{@report[:found_products].size + @report[:found_options].size}")
			end
		end
	end
end
