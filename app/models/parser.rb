# == Schema Information
#
# Table name: parsers
#
#  id          :bigint           not null, primary key
#  name        :string
#  settings    :jsonb
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  provider_id :bigint           not null
#
# Indexes
#
#  index_parsers_on_provider_id  (provider_id)
#
# Foreign Keys
#
#  fk_rails_...  (provider_id => providers.id)
#
class Parser < ApplicationRecord
	CONFIG_PATH = "config/parsers.yml"

	belongs_to :provider
	has_many :imports, as: :importable

	scope :slug, -> (slug) { where(slug: slug) }

	store_accessor :settings, :url,
	               :col_sep,
	               :download_type,
	               :category_find_target_column_name,
	               :header_row,
	               :header_map,
	               :start_row,
	               :short_name,
	               :spreadsheet_sync_url,
	               :encoding,
	               :categories,
	               :pages,
	               :parse_type,
	               :path,
	               :google_doc_id,
	               :sku_column,

	               def self.download_file(parser_name)
		               parser = Parser.find_by(name: parser_name)

		               # return parser.path if parser
		               DownloadFileService.new(options: parser).download!
	               end
end
