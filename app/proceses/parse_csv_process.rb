class ParseCsvProcess

	def initialize(name)
		@name = name
		@parser = Parser.find_by(name: @name)
	end

	def start
		return 'not found' unless @parser
		process(@parser)
	end

	private

	def process(parser)
		file_path = DownloadFileService.new(options: parser).download!
		csv_file = CsvParserService.new(path: file_path, encoding: @parser.encoding, col_sep: @parser.col_sep).parse!
		binding.pry
		csv_file.headers.map { |header| header.downcase.underscore }
		# csv_file.each do |row|
		#
		# end
	end
end