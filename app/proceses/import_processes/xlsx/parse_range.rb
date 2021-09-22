class ImportProcesses::Xlsx::ParseRange
	attr_reader :spreadsheet, :parser

	def initialize(parser:, spreadsheet:, page:, range:)
		@parser = parser
		@spreadsheet = spreadsheet
		@sku_column = parser.sku_column
		@sku_name = parser.header_map[parser.sku_column.to_s]
		@provider = Provider.find_by(slug: parser.slug)
		@header = parser.header_map
		@range = range
		@page = page
		@new_products = []
		@new_options = []
	end

	def process!
		parse
	end

	private

	def parse
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

					import = @parser.imports.new(provider: @provider)
					import.import_products.new(row_number: row,
					                           product_id: @product.id,
					                           import_id: import.id,
					                           page_name: @page).save!
					import.save!
				end
				@new_products << @product
			end
		end

		Rails.logger.info("Add new products count: #{@new_products.size + @new_options.size}")
	end

	def add_options(options)
		options.each do |option_row|
			option_sku = spreadsheet.cell(option_row, @sku_column).to_i.to_s
			next if Option.find_by(sku: option_sku)
			@product.options.new(sku: option_sku, data: row_data)
			@new_options << @product.options
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