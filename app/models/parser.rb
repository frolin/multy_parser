class Parser < ApplicationRecord
  store_accessor :settings, :url, :categories, :parser_type

  CONFIG_PATH = "config/parsers.yml"

  def self.load_default!
    YAML.load_file(CONFIG_PATH).each { |parser| self.create!(parser[1].values.first) }
  end
end
