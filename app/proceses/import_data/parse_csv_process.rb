class ImportData::ParseCsvProcess

  def initialize(name)
    @name = name
    @parser = Parser.find_by(name: @name)
  end

  def start
    return "Not found parser name: #{@name}" unless @parser
    process
  end

  private

  def process
    csv = Parser::CsvParser.new(path: download_file, encoding: @parser.encoding, col_sep: @parser.col_sep).parse!

    # новый импорт
    import = @parser.imports.new

    csv.each_with_index do |row, row_num|
      # Если продукт уже есть
      next if Product.exists?(row.to_h['Артикул'])

      # создаём продукт
      product = import.products.new(name: @parser.name, data: row.to_h)

      # находим категории
      ProductData::CategoryService.new(product, @parser.category_find_target_column_name).categorize!

      # добавляем артикул
      ProductData::SkuService.new(product, @parser.slug).add_sku!

      # добавляем мета теги
      ProductData::MetaTagsService.new(product)

      # сртируем перед сохранением
      product.data.sort.to_h

      product.save!
    end

    import.save!

    Export::GoogleDriveService.new(@parser).sync

    puts "#{self.class.name} end process"
  end

  def download_file
    Import::DownloadFileService.new(options: @parser).download!
  end

end