module Parsers
	class BaseParser
		def self.read(name)
			Parser.find_by(name: name)
		end

		def initialize(agent: Mechanize.new, type:, url:)
			@url = url
			@type = type
			@agent = agent
		end

		def start
			name = @type.to_s.capitalize

			strategy = Parsers.const_get("#{name}Parser").new
			strategy.url = @url if @url
			strategy.parse!
		end

		def parse!
			raise NotImplementedError
		end

		private

		def page
			@page ||= @agent.get(@url)
		end

		def parsing
		end

		def parse
			page
		end
	end
end
