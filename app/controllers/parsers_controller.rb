class ParsersController < ApplicationController
	def index
	end

	def parse
		Parsers::BaseParser.new(agent: Mechanize.new, type: params[:type], url: params[:url])
	end
end
