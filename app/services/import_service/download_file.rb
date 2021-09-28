module ImportService
	class DownloadFile

		def initialize(agent: Mechanize.new, parser:)
			@url = parser.url
			@agent = agent
			@name = parser.name
			@slug = parser.slug
			@parser_type = parser.parse_type
		end

		def download!
			download_file # if not exist?
		end

		private

		def path
			path = "public/parsers/#{@name}"
			@path ||= "#{path}/#{@slug}.#{@parser_type}"
		end

		def file
			@agent.pluggable_parser.default = Mechanize::Download
			@file ||= @agent.get(@url)
		end

		def download_file
			if new_file?
				@tempfile = Down.download(@url)
				FileUtils.mv(@tempfile.path, path)
				Rails.logger.info "Download file to #{path}"
				path
			else
				Rails.logger.info 'File already exists with same size'
				path
			end
		end

		def new_file?
			!File.exists?(path) && !FileUtils.compare_file(@tempfile, path)
		end
	end
end