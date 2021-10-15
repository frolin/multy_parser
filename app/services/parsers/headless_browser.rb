require "selenium-webdriver"

module Parsers
	class HeadlessBrowser
		def initialize(url, element)
			@url = url
			@element = element
		end

		def find
			browser.get @url

			first_hd_picture = wait.until { browser.find_element(css: '.serp-item__hd') }
			first_hd_picture.find_element(xpath: "../../..").click

			wait.until { browser.find_element(xpath: "//*[text()='Открыть']") }.click


			image_href = wait.until { browser.find_element(css: @element) }.attribute('href')

			Rails.logger.debug('quit browser')

			browser.quit

			image_href

		rescue StandardError => e
			Rails.logger.error("element not found")
			nil
		end

		def browser
			@browser ||= Selenium::WebDriver.for :chrome, options: options
		end

		def options
			options = Selenium::WebDriver::Chrome::Options.new
			options.add_argument('--headless')
			options.add_argument('--enable-javascript')
			options.add_argument('--no-sandbox')
			options.add_argument('--ignore-certificate-errors')
			options.add_argument('--allow-insecure-localhost')
			options.add_argument("--window-size=1920,1080")
			options.add_argument("--start-maximized")

			options
		end

		def wait
			@wait = Selenium::WebDriver::Wait.new(:timeout => 10)
		end
	end
end