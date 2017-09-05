class Catalog
  attr_accessor :catalog_array, :catalog_file

  def initialize(catalog_name)
    @catalog_array = []
    @catalog_file = if File.exist?(catalog_name)
      File.open(catalog_name, 'r+')
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

  def length
    @catalog_array.length
  end
end
