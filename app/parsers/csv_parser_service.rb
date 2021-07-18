require 'csv'

class CsvParserService
	def initialize(path:, col_sep:, encoding:, headers: true)
		@encoding = encoding
		@path = path
		@col_sep = col_sep
		@headers = headers
	end

	def parse!
		CSV.read(@path, col_sep: @col_sep, encoding: "#{@encoding}:utf-8", headers: @headers)
	end
end
