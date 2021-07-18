class DownloadFileService

  def initialize(agent: Mechanize.new, options:)
    @url = options.url
    @agent = agent
    @name = options['name']
    @path = "public/parsers/#{options['name']}"
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
    @page ||= @agent.get(@url)
  end

  def download_file
    file.save("#{@path}/#{@page.filename}")
  end
end