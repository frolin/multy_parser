class ImportProcesses::Xlsx::ParseRange < ImportProcess
	attr_reader :report

	def initialize(parser:, spreadsheet:, page:, range:)
		super(parser: parser)

		@spreadsheet = spreadsheet
		@range = range
		@page = page
		@sku_column = parser.sku_column
		@sku_name = parser.header_map[parser.sku_column.to_s]
		@header = parser.header_map
	end

	def process!
		process
	end

	private

	def process
		@range.each do |row, options|
			@current_row = row

			@product = Product.find_or_initialize_by(sku: sku) do |product|
				product.sku = sku
				product.name = clean_name(row_data)
				product.data = row_data
				product.provider = @provider
			end

			add_options(options) if options.present?

			if @product.new_record?
				ActiveRecord::Base.transaction do
					@product.category = @page
					@product.save

					import = @parser.imports.new(provider: @provider)
					import.import_products.new(row_number: row,
					                           product: @product,
					                           page_name: @page).save!
					import.save!
				end

				@report[:new_products] << @product
				next
			end

			@report[:found_products] << @product
		end
	end

	def add_options(options)
		@main_product = row_data

		options.each do |option_row|
			@current_row = option_row

			option_sku = row_data[@sku_name]

			if Option.find_by(sku: option_sku)
				@report[:found_options] << @product.options
				next
			end

			@option = @product.options.new(sku: option_sku,
			                     data: row_data.merge('НАИМЕНОВАНИЕ' => @main_product['НАИМЕНОВАНИЕ']),
			                     name: clean_name(@main_product))

			@option.category = @page

			@report[:new_options] << @option
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

	def clean_name(product)
		ActionController::Base.helpers.strip_tags(product['НАИМЕНОВАНИЕ']).to_s.squish
	end

	def options_data
		parametes = ['ОБЪЕМ', 'ТАРА', 'В КОРОБКЕ']


	end

	def sku
		row_data[@sku_name]
	end
end