module Parsers
	class ParserService
		def self.read(name)
			Parser.find_by(name: name)
		end

		def initialize(agent: '', type:, url:)
			@url = url
			@type = type
			@agent = agent
		end

		def start
			binding.pry
       name = @type.to_s.capitalize

      strategy = Parsers.conts_get(name).new
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