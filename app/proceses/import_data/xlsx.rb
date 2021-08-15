class ImportData::Xlsx
	attr_reader :spreadsheet, :parser

	def initialize(parser:, spreadsheet:)
		@parser = parser
		@spreadsheet = spreadsheet
	end

	def process!
		process
	end

	private

	def process
		parse(filtered_pages)
	end

	def filtered_pages
		spreadsheet.sheets.select { |sheet| sheet.in?(parser.pages) }
	end

	def parse(filtered_pages)
		import = parser.imports.new(provider: parser.provider)

		filtered_pages.each do |page|
			header = parser.header_map

			table_range.each { |row_num|

				next if spreadsheet.row(row_num).compact.size < 5

        row_data = {}

        header.each do |col_num, name|
          data = spreadsheet.row(row_num)
          row_data[name] = data[ col_num.to_i - 1 ]
        end


				next unless product_add?(row_data)

				if product_option?(row_data)
					# DANGER!
          Product.find_by(sku: spreadsheet.row(row_num)).options.new(sku: row_data[parser.sku], data: row_data, provider: parser.provider).save!
        elsif row_data[parser.sku].present?
					import.products.new(sku: row_data[parser.sku], data: row_data, provider: parser.provider).save!
        else
          next
        end

			}
		end
		import.save!
	end

	def table_range
		(parser.start_row ..spreadsheet.last_row - 2)
	end

	def product_option?(row_data)
		row_data[parser.sku].present? && row_data['НАИМЕНОВАНИЕ'].blank?
	end

	def product_add?(row_data)
		return false if row_data.compact.blank?

		row_data[parser.sku].present? || Product.find_by(sku: row_data[parser.sku])
	end
end


