class ImportData::Xlsx
  def initialize(parser:)
    @parser = parser
  end

  def process!
    process
  end

  def spreadsheet
    @spreadsheet ||= ImportData::GoogleSpreadsheet.new(@parser.google_doc_id).spreadsheet
  end

  private

  def process
    parse(filtered_pages(spreadsheet))
  end

  def filtered_pages(spreadsheet)
    spreadsheet.sheets.select { |sheet| sheet.in?(@parser.pages) }
  end

  def parse(filtered_pages)
    import = @parser.imports.new(provider: @parser.provider)

    filtered_pages.each do |page|
      header = spreadsheet.row(@parser.start_row)

      table_range.each { |row|
        next unless product_add?

        binding.pry

        row_data = Hash[[header, spreadsheet.row(row)].transpose]
        import.products.new(sku: row_data[@parser.sku], data: row_data, provider: @parser.provider)
      }
    end
    import.save!
  end

  def table_range
    ((@parser.start_row + 1)..spreadsheet.last_row)
  end

  def product_add?(row_data)
    row_data[@parser.sku].blank? || Product.find_by(sku: row_data[@parser.sku])
  end

end


