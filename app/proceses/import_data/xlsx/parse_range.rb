class ImportData::Xlsx::ParseRange
	attr_reader :spreadsheet, :config

	def initialize(config:, spreadsheet:, range:)
		@config = config
		@spreadsheet = spreadsheet
		@sku_column = config.sku_column
		@sku_name = config.header_map[config.sku_column.to_s]
		@provider = config.provider
		@header = config.header_map
		@range = range[:product_map]
		@page = range[:page_name]
		@new_records = []
	end

	def process!
		case @range
		when is_a?(Array) then parse_all(@range)
		when is_a?(Hash) then parse(@range)
		else
			parse(@range)
		end
	end

	private

	def parse_all(ranges)
		ranges.each do |range|
			@sheet_name = range[:page_name]
			puts "Parse #{range[:page_name]}"
			parse(range)
		end

		ap "add: #{@new_records}"
	end

	def parse(range)
		import = @config.imports.new(provider: @provider)

		@range.each do |row, options|
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
			@new_records << @product
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

	def row_data
		row_data = {}

		@header.each { |col_num, name|
			sheet = @spreadsheet.sheet(@page)
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

end