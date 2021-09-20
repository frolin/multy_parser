module ImportService
	class DownloadFile

		def initialize(agent: Mechanize.new, parser:)
			@url = parser.url
			@agent = agent
			@name = parser.name
			@path = "public/parsers/#{@name}"
		end

		def download!
			download_file # if not exist?
		end

		private

		def exist?
			@path
		end

		def file
			@agent.pluggable_parser.default = Mechanize::Download
			@file ||= @agent.get(@url)
		end

		def download_file
			tempfile = Down.download(@url)
			path = "#{@path}/#{tempfile.original_filename}"

			if new_file?(tempfile)
				FileUtils.mv(tempfile.path, path)
				path
			else
				puts 'file already exists with same size'
				path
			end
		end

		def new_file?(tempfile)
			file_path = "#{@path}/#{tempfile.original_filename}"
			!File.exists?(file_path) ||	FileUtils.compare_file(tempfile,file_path)
		end
	end
end