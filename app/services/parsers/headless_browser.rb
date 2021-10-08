require "selenium-webdriver"

module Parsers
	class HeadlessBrowser
		def initialize(url, element)
			@url = url
			@element = element

			options = Selenium::WebDriver::Chrome::Options.new
			options.add_argument('--headless')
			options.add_argument('--enable-javascript')
			options.add_argument('--no-sandbox')
			options.add_argument('--ignore-certificate-errors')
			options.add_argument('--allow-insecure-localhost')
			options.add_argument("--window-size=1920,1080")
			options.add_argument("--start-maximized")
			@driver = Selenium::WebDriver.for :chrome, options: options
			@wait = Selenium::WebDriver::Wait.new(:timeout => 10)
		end

		def find
			@driver.get @url
			@driver.find_element(css: 'a.serp-item__link').click

			image = @wait.until { @driver.find_element(css: @element) }
			image.attribute('src')
		end
	end
end