module ImportService::ImportReport
	# This is the magical bit that gets mixed into your classes
	def report
		@report
	end

	# Global, memoized, lazy initialized instance of a report
	def self.report
		@report ||= { new_products: [], old_products: [], new_options: [], old_options: [] }
	end
end