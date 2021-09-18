class ImportProducts
	def initialize(parser:)
		@parser = parser
	end

	def import
		case @parser.download_type
		when 'url'
			binding.pry
		else
			binding.pry
		end
	end




end