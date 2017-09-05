require 'mechanize'
load 'parser.rb'
load 'catalog.rb'

include Parser

catalog = Catalog.new('catalog.txt')

main_page = Mechanize.new.get('http://www.a-yabloko.ru/catalog/')
group_links = scan_main(main_page)

group_links.each do |link|
  scan_page(link)
end

catalog.read_catalog(products_array)

catalog.save