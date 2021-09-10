class ImportData::Xlsx
	attr_reader :spreadsheet, :parser, :current_row

	def initialize(parser:, spreadsheet:)
		@parser = parser
		@spreadsheet = spreadsheet
		@sku_name = @parser.sku
		@provider = @parser.provider
	end

	def process!
		process
	end

	private

	def process
		find_ranges(filtered_pages)
		parse(filtered_pages)
	end

	def filtered_pages
		spreadsheet.sheets.select { |sheet| sheet.in?(parser.pages) }
	end

	# def find_product_range
	# 	products = []
	# 	product = {}
	#
	# 	filtered_pages.each do |page|
	# 		table_range.each_with_index do |row_num, index|
	# 			@current_row = row_num
	# 			product[:row] = row_num
	#
	# 			if product_main?(@current_row)
	# 				product[:base_product] = @current_row
	# 			end
	#
	# 			if product_option?(@current_row)
	# 				product[:base_product][:options] = @current_row
	# 			end
	#
	# 			products << product
	# 		end
	# 	end
	# 	products
	# end

	def parse(filtered_pages)
		import = parser.imports.new(provider: @provider)

		filtered_pages.each do
			table_range.each do |row_num|
				@current_row = row_num

				if product_main?
					product = Product.new(sku: row_data[@sku_name].to_i, name: row_data['НАИМЕНОВАНИЕ'], data: row_data, provider: @provider)
					product.main = product_main?
					import.products << product
					import.save!
				end

				if product_option?
					@main_product_row = @current_row - 1

					(@current_row..spreadsheet.last_row).each { |row|
						next if product_main?

						# binding.pry
						main_product_sku = row_data[@sku].to_i
						product = Product.find_by(sku: main_product_sku)
						product.options.new(sku: row_data[parser.sku].to_i, data: row_data).save! if product
					}

				end
			end
		end

		import.save!
	end

	def find_ranges(pages)
		pages.each do |page|
			find_range(page)
		end
	end


	def find_range(page)
		products = []

		table_range(page).each do |row_num|
			@current_row = row_num

			if product_main?
				products << row_num
			end

			if product_option?
				products << [row_num]
			end



			end

		binding.pry
		#
		# range_last = ''
		# range_first = ''
		#
		# (@current_row..parser.start_row).map do |row_num|
		# 	range_first = row_num - 1 if product_main?
		# end
		#
		# (@current_row..spreadsheet.last_row).map do |row_num|
		# 	range_last = row_num - 1 if product_main?
		# end

		# (range_first..range_last)
	end

	def table_range(page)
		(parser.start_row..spreadsheet.sheet(page).last_row - 2)
	end

	def product_option?
		row_data[@sku_name].present? && row_data['НАИМЕНОВАНИЕ'].blank?
	end

	def product_main?
		row_data[@sku_name].present? && row_data['НАИМЕНОВАНИЕ'].present?
	end

	def row_data
		row_data = {}

		header.each { |col_num, name|
			data = spreadsheet.row(@current_row)
			row_data[name] = data[col_num.to_i - 1]
		}
		row_data
	end


	def header
		@header ||= parser.header_map
	end

	def next_row_data
		next_row_data = {}

		header.each { |col_num, name|
			data = spreadsheet.row
			next_row_data[name] = data[col_num.to_i - 1]
		}

		next_row_data
	end

	def row_valid?(row_data)
		return false if row_data.compact.blank?

		row_data[@sku].present? || Product.find_by(sku: row_data[parser.sku])
	end
end


