module Parsers
	class XmlParser
		attr_accessor :url

		def initialize
		end

		def parse!
			@doc = Nokogiri::HTML(URI.open(url)) if url.present?
		end
	end

end
