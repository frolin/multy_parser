class ParserService
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