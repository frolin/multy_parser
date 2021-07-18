class Parser < ApplicationRecord
	store_accessor :settings, :url, :col_sep, :encoding, :categories, :parser_type, :path

	CONFIG_PATH = "config/parsers.yml"

	def self.load_default!
		YAML.load_file(CONFIG_PATH).each do |parser|
			next if Parser.find_by(name: parser[1].values.first['name'])
			self.create!(parser[1].values.first)
		end
	end


	def self.download_file(parser_name)
		parser =  Parser.find_by(name: parser_name)

		# return parser.path if parser
		binding.pry
		DownloadFileService.new(name: parser.name, url: parser.url).download!
	end
end
