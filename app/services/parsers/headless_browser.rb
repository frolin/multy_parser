require "selenium-webdriver"

module Parsers
	class HeadlessBrowser

		def self.go_and_find(url, element)
			# configure the driver to run in headless mode
			#
			options = Selenium::WebDriver::Chrome::Options.new
			# options.add_argument('--headless')
      options.add_argument('--enable-javascript')
      options.add_argument('--no-sandbox')
      options.add_argument('--ignore-certificate-errors')
      options.add_argument('--allow-insecure-localhost')
			driver = Selenium::WebDriver.for :chrome, options: options

			driver.get url
			wait = Selenium::WebDriver::Wait.new(:timeout => 10)
			element = wait.until { driver.find_element(css: element) }

			element.attribute('src') if element.present?
		end
	end
end