module Parser
  attr_accessor :depth, :products_array

  def scan_main(page)
    @products_array = []
    Parser.depth = 0
    parse_page(page, '#catalog-content .children a', 'group', '-')
  end

  def parse_page(page, tag, type, group)
    hrefs = page.search(tag).map do |row|
      name = row.text.sub(/\d*$/, '')
      if type == 'product'
        name = row['title']
      end
      pic = File.basename(row['style'].scan(/url\((.*)'./).join)
      new_record(type, group, name, pic)
      row['href']
    end
    hrefs.map { |link| page.link_with(href: link) }
  end

  def scan_page(link)
    Parser.depth += 1
    page = link.click
    group = link.text.sub(/\d*$/, '')
    subgroups = find_subgroups(page, group)
    if subgroups.empty?
      scan_products(page, group)
    else
      subgroups.each { |subgroup| scan_page(subgroup) }
    end
    Parser.depth -= 1
  end

  def new_record(type, group, name, pic)
    record = "#{type}\t#{group}\t#{name}\t#{pic}\n"
    @products_array << record
    puts record
  end

  def find_subgroups(page, group)
    type = 'sub-' * Parser.depth + 'group'
    parse_page(page, '#content.bar .children a', type, group)
  end

  def scan_products(page, group)
    type = 'product'
    parse_page(page, '#content.bar .goods .img', type, group)
  end
end

