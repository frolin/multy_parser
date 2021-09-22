class ImportProcess
	def initialize(parser:, file_path:)
		@parser = parser
		@file_path = file_path
		@parser_type = parser.parse_type.capitalize
	end

	def process!
		ImportProcesses.const_get(@parser_type).new(parser: @parser, file_path: @file_path).process!
	end

end