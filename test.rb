require 'mechanize'

link = 'http://www.a-yabloko.ru/'

@agent = Mechanize.new
 
@page = @agent.get(link).link_with(text: "Каталог товаров").click


@page = @agent.get('http://www.a-yabloko.ru').link_with(text: "Каталог товаров").click


page2 = @agent.get('http://www.a-yabloko.ru/catalog/272/')




page2.search('#content.bar .goods .img').map do |row|


page2.search('#content.bar .goods .img').map do |row|
row.attributes["href"][(/\d*$/)]
end


@iid = page.at("table[@class='goods']").css("td input").map { |node| node[:id][/\d+/] }


http://www.a-yabloko.ru/catalog/

page = @page

categories = page.at("div[@class='children']")


categories.each do |category|
	puts category
end  

categories.each do |category|
	puts category.text
end  

номера и названия каталогов
