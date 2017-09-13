class Catalog
  attr_accessor :catalog_array, :catalog_file, :catalog

  def initialize(catalog_name)
    Dir.mkdir('pictures') unless File.exists?('pictures')
    @catalog_array = []
    @catalog_file = if File.exist?(catalog_name)
      File.open(catalog_name, 'a+')
    else
      File.open(catalog_name, 'w+')
    end
    @catalog_array << File.readlines(catalog_name)
  end

  def read_catalog(catalog)
    @catalog_array = catalog - @catalog_array
  end

  def save
    @catalog_array.each do |row|
      @catalog_file << row
    end
  end
end
