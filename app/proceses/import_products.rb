class ImportProducts
	def initialize(slug:)
		@parser = Parser.find_by(slug: slug)
	end

	def import
		file_path = ImportService::DownloadFile.new(parser: @parser).download!
		ImportProcess.new(parser: @parser, file_path: file_path).process!

		products = Product.by_provider(@parser.slug)

		Parsing::Images::Google.new(products).parse!
		binding.pry

		# Export::GoogleDriveService.new(@parser).sync
	end
end