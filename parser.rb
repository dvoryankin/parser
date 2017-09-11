require './statistics'
require './catalog'
require 'pry'

module Parser
  attr_accessor :depth, :products_array, :stats

  def scan_main(page)
    @products_array = []
    @stats = Statistics.new
    Parser.depth = 0
    parse_page(page, '#catalog-content .children a', 'group', '-')
  end

  def parse_page(page, tag, type, group)
    hrefs = page.search(tag).map do |row|
      name = row.text.sub(/\d*$/, '')
      id = row.text.scan(/\d*$/).flatten[0]
      if type == 'product'
        name = row['title']
      end
      pic = take_pic_name(row)
      sub_id = page.uri.path.scan(/\/(\d+)\//).flatten[0]

      if row.attributes["href"].to_s.scan(/\/(\d+)\//)[1].nil?
        iid = '- - -'
      else
        iid = row.attributes["href"].to_s.scan(/\/(\d+)\//)[1][0]
      end

      record = "#{type}\t#{group}\t#{name}\t#{id}\t#{pic}\t#{sub_id}\t#{iid}\n"

      item_id_arr = record.split("\t")[-1]
      sub_id_arr = record.split("\t")[-2]
      id_arr = record.split("\t")[-4]

      p record.split("\t")

      puts item_id_arr
      puts sub_id_arr
      puts id_arr

      last_iid = []

      File.readlines('catalog.txt').each do |line|
        last_iid << line.split("\t")[-1]
        last_iid << line.split("\t")[-2]
        last_iid << line.split("\t")[-4]
      end

      if last_iid.include? item_id_arr
        @stats.total_items -= 1
      elsif last_iid.include? sub_id_arr
        @stats.total_items -= 0
      elsif last_iid.include? id_arr
        @stats.total_items -= 0
      end

      @products_array << record
      @stats.total_items += 1
      @stats.items_in_group[@current_group] += 1 if Parser.depth >= 1

      puts "#{@stats.total_items} - #{record}"

      if @stats.total_items == 44
        @stats.print_statistics
        @catalog.read_catalog(products_array)
        @catalog.save
        exit
      end
      row['href']
    end
    hrefs.map { |link| page.link_with(href: link) }
  end

  def scan_page(link)
    Parser.depth += 1
    page = link.click
    group = link.text.sub(/\d*$/, '')
    @current_group = group if Parser.depth == 1
    subgroups = find_subgroups(page, group)
    if subgroups.empty?
      scan_products(page, group)
    else
      subgroups.each { |subgroup| scan_page(subgroup) }
    end
    Parser.depth -= 1
  end

  def find_subgroups(page, group)
    type = 'sub-' * Parser.depth + 'group'
    parse_page(page, '#content.bar .children a', type, group)
  end

  def scan_products(page, group)
    type = 'product'
    parse_page(page, '#content.bar .goods .img', type, group)
  end

  def take_pic_name(row)
    pic_name = File.basename(row['style'].scan(/url\((.*)'./).join)
    if pic_name == ''
      pic_name = '-'
      @stats.item_without_picture
    else
      @stats.save_pic(pic_name)
      @stats.check_size(pic_name)
    end
    pic_name
  end
end
