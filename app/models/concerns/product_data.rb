module ProductData
	extend ActiveSupport::Concern

	BASE_PERCENT = 67

	included do
		store_accessor :data, :category, :parser_name, :product_image_url, :vendor_code, :price

		validates :sku, uniqueness: true, presence: true
		before_create :generate_price #, :create_vendor_code,

		scope :search, ->(name) { where('name ILIKE ?', "%#{name}%") }
		scope :by_provider, -> (slug) { joins(:provider).where(providers: { slug: slug }) }
		scope :by_category, -> (category) { where(category: category) }
	end

	def self.exists?(value)
		self.where('data @> ?', { 'Артикул': value }.to_json).exists? || where(sku: value).exists?
	end

	def barcode
		data['ШТРИХ-КОД']
	end

	def create_vendor_code
		self.vendor_code = "#{provider.slug}-#{barcode.last}"
	end

	def generate_price
		return if data['ЦЕНА ОПТ.'].blank?

		self.price = (data['ЦЕНА ОПТ.'] / 100 * (100 + BASE_PERCENT)).to_i
	end
end