class ImportProcess
	def initialize(parser:, file_path: nil)
		@parser = parser
		@range = {}
		@file_path = file_path
		@parser_type = parser.parse_type.capitalize
		@sku_column = parser.sku_column
		@provider = Provider.find_by(slug: parser.slug)
		@report ||= { new_products: [], found_products: [], new_options: [], found_options: [] }
	end

	def process!
		import = ImportProcesses.const_get(@parser_type).new(parser: @parser, file_path: @file_path)
		timing = Benchmark.measure { import.process! }

		Rails.logger.info("Exec time measure: #{timing}")
	end
end