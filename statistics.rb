require 'open-uri'
class Statistics
  attr_accessor :total_items, :items_in_group, :items_without_picture

  def initialize
    @total_items = 0
    @items_in_group = Hash.new(0.0)
    @group_percent_of_total = {}
    @items_without_picture = 0.0
    @percent_items_with_pic = 0.0
    @max_size_pic = {}
    @min_size_pic = {}
    @min_size_pic[:size] = 100_000_000.0
    @max_size_pic[:size] = 0.0
  end

  def item_without_picture
    @items_without_picture += 1
  end

  def check_size(pic)
    picture_size = File.size('pictures/' + pic)
    if picture_size > @max_size_pic[:size]
      @max_size_pic[:size], @max_size_pic[:name] = picture_size, pic
    else
      if picture_size < @min_size_pic[:size]
        @min_size_pic[:size], @min_size_pic[:name] = picture_size, pic
      end
    end
  end

  def calculate_statistics
    @items_in_group.each do |group, count|
      @group_percent_of_total[group] = 100 * count / @total_items
    end

    items_with_picture = @total_items - @items_without_picture
    @percent_items_with_pic = 100.0 * items_with_picture / @total_items

    @min_size_pic[:size] /= 1024
    @min_size_pic[:size] = @min_size_pic[:size].round(1)
    @max_size_pic[:size] /= 1024
    @max_size_pic[:size] = @max_size_pic[:size].round(1)
  end

  def print_statistics
    calculate_statistics
    puts 'Summary'
    @items_in_group.each do |group, count|
      puts "#{group}: #{count} items, #{@group_percent_of_total[group]}% of total"
    end
    puts "Percent goods with pictures: #{@percent_items_with_pic}%"
    puts "Top size image: #{@max_size_pic[:name]}; size: #{@max_size_pic[:size]} kB"
    puts "Least size image: #{@min_size_pic[:name]}; size: #{@min_size_pic[:size]} kB"
  end

  def save_pic(name)
    open('pictures/' + name, 'wb') do |file|
      file << open('http://www.a-yabloko.ru/storage/catalog/goods/.thumbs/' + name).read
    end
  end
end
