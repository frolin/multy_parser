class ParserService

	def self.read(name)
		Parser.find_by(name: name)
	end

	def initialize(agent: Mechanize.new, type:, url:)
		@url = url
		@type = type
		@agent = agent
	end

	def parse!
		parse
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