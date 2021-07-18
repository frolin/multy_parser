class ParsersController < ApplicationController
	def index
	end

	def parse
		ParserService.new(agent: Mechanize.new, type: params[:type], url: params[:url])
	end
end
