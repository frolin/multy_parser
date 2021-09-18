module Parsing

	class ParseXlsx
		attr_reader :parser

		def initialize(name)
			@name = name
			@parser = Parser.find_by(name: @name)
		end

		def start!
			return "Not found parser name: #{@name}" unless @parser
			process
		end

		private

		def process
			GoogleSpreadsheet.new(parser.gooogle_doc_id) if parser.gooogle_doc_id.present?
		end
	end
end
