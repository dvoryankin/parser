require 'mechanize'
require './parser'
require './catalog'

include Parser

@catalog = Catalog.new('catalog.txt')


@last_iid = Set.new
File.readlines('catalog.txt').each do |line|
  @last_iid << line.split("\t")[-1].chomp
end

main_page = Mechanize.new.get('http://www.a-yabloko.ru/catalog/')
group_links = scan_main(main_page)

group_links.each do |link|
  scan_page(link)
end
