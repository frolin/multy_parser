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

  store_accessor :settings, :url,
                 :col_sep,
                 :category_find_target_column_name,
                 :sku,
                 :start_row,
                 :short_name,
                 :spreadsheet_sync_url,
                 :encoding,
                 :categories,
                 :pages,
                 :parser_type,
                 :path,
                 :google_doc_id


  def self.download_file(parser_name)
    parser = Parser.find_by(name: parser_name)

    # return parser.path if parser
    DownloadFileService.new(options: parser).download!
  end
end
