module ImportProcesses
	class ParseSite
		def initialize(agent: Mechanize.new, parser:)
			@agent = agent
			@url = parser.url
			@parser = parser
			@category_list = []
		end

		def start
			process
		end

		def process!
			find_categories(@parser['categories_css_path'])
			Rails.logger.info "#{self.class.name} end process"
		end

		def page
			@page ||= @agent.get(@url)
		end

		def find_categories(path)
			categories = page.search(path)
			category_name = {}

			categories.each do |category|
				next if exclude_category?(category)
				next if empty_category?(category)
				category_name["#{category.text}"] = { url: category.attributes['href'].value }
				@category_list << category_name
			end
		end

		def exclude_category?(category)
			exclude_categories = @parser['exclude_categories'].map(&:downcase)
			category.content.to_s.squish.downcase.in?(exclude_categories)
		end

		def empty_category?(category)
			category.content.to_s.squish.blank?
		end
	end
end
