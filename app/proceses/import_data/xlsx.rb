class ImportData::Xlsx
	attr_reader :spreadsheet, :parser, :current_row

	def initialize(parser:, spreadsheet:)
		@parser = parser
		@spreadsheet = spreadsheet
		@sku_column = parser.sku_column
		@sku_name = parser.header_map[parser.sku_column.to_s]
		@provider = parser.provider
	end

	def process!
		process
	end

	private

	def process
		ranges = find_ranges(filtered_pages)
		parse_all(ranges)
	end

	def filtered_pages
		spreadsheet.sheets.select { |sheet| sheet.in?(parser.pages) }
	end

	def find_ranges(pages)
		pages.map do |page|
			{ page_name: page, product_map: find_range(page) }
		end
	end

	def parse_all(ranges)
		ranges.each do |range|
			@sheet_name = range[:page_name]
			puts "Parse #{range[:page_name]}"
			parse(range)
		end
	end

	def parse(range)
		import = parser.imports.new(provider: @provider)

		range[:product_map].each do |row, options|
			@current_row = row
			clean_name = ActionController::Base.helpers.strip_tags(row_data['НАИМЕНОВАНИЕ']).to_s.squish
			sku = row_data[@sku_name]

			@product = Product.find_or_initialize_by(sku: sku) do |product|
				product.sku = sku
				product.name = clean_name
				product.data = row_data
				product.provider = @provider
			end

			add_options(options) if options.present?

			if @product.new_record?
				ActiveRecord::Base.transaction do
					@product.save
					import.import_products.new(row_number: row, product_id: @product.id, import_id: import.id, page_name: range[:page_name]).save!
					import.save!
				end
			end
		end
	end

	def add_options(options)
		options.each do |option_row|

			option_sku = spreadsheet.cell(option_row, @sku_column).to_i.to_s
			next if Option.find_by(sku: option_sku)
			@product.options.new(sku: option_sku, data: row_data)
		end
	end

	def find_range(page)
		basic_products = {}
		main_product_row ||= parser.start_row

		table_range(page).each do |row_num|
			@current_row = row_num
			@sheet_name = page

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
			sheet = spreadsheet.sheet(@sheet_name)
			data = sheet.row(@current_row)
			margin = 2
			sku_column = @sku_column - margin

			if data[sku_column].class == Float
				data[sku_column] = data[sku_column].to_i.to_s
			end

			row_data[name] = data[col_num.to_i - margin]
		}
		row_data
	end

	def header
		@header ||= parser.header_map
	end
end


