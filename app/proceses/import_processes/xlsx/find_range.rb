class ImportProcesses::Xlsx::FindRange
	def initialize(parser:, spreadsheet:, page:)
		@parser = parser
		@spreadsheet = spreadsheet
		@sku_column = parser.sku_column
		@sku_name = parser.header_map[parser.sku_column.to_s]
		@provider = parser.provider
		@header = parser.header_map
		@page = page
	end

	def process!
		find_range
	end

	private

	def find_range
		basic_products = {}
		main_product_row ||= @parser.start_row

		table_range.each do |row_num|
			@current_row = row_num

			if product_main?
				basic_products[row_num] = []
				main_product_row = row_num
			end

			if product_option?
				basic_products[main_product_row] << row_num
			end
		end

		basic_products
	end

	def table_range(offset = nil)
		(@parser.start_row..@spreadsheet.sheet(@page).last_row - (offset || 2))
	end

	def product_option?
		row_data[@sku_name].present? && row_data['НАИМЕНОВАНИЕ'].blank?
	end

	def product_main?
		row_data[@sku_name].present? && row_data['НАИМЕНОВАНИЕ'].present?
	end

	def row_data
		row_data = {}

		@header.each { |col_num, name|
			sheet = @spreadsheet.sheet(@page)
			data = sheet.row(@current_row)
			margin = 2
			sku_column = @sku_column - margin
			#
			# if data[sku_column].class == Float
			# 	data[sku_column] = data[sku_column].to_i.to_s
			# end

			row_data[name] = data[col_num.to_i - margin]
		}
		row_data
	end

end
