class FindImages
	def self.find(parser:, products:)
		new(parser: parser, products: products).process
	end

	def initialize(parser:, products:)
		@parser = parser
		@products = products
	end

	def process
		Parsing::Images::Base.new(parser: @parser, products: @products).parse!
	end
end


