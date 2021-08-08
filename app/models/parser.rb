# == Schema Information
#
# Table name: parsers
#
#  id         :bigint           not null, primary key
#  name       :string
#  settings   :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Parser < ApplicationRecord
	CONFIG_PATH = "config/parsers.yml"

	store_accessor :settings, :url, :slug, :col_sep,
	               :encoding, :categories, :parser_type, :path, :category_find_target_column_name,
	               :spreadsheet_sync_url

	has_many :imports, as: :importable

	def self.load_default!
		parsers = YAML.load_file(CONFIG_PATH)['parsers']
		parsers.each do |parser|
			next if Parser.find_by(name: parser[1]['name'])
			self.create!(parser[1])
		end
	end

	def self.download_file(parser_name)
		parser = Parser.find_by(name: parser_name)

		# return parser.path if parser
		DownloadFileService.new(options: parser).download!
	end
end
