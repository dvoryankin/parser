require 'open-uri'
class Statistics
  attr_accessor :total_items, :items_in_group, :items_without_picture

  def initialize
    @total_items = 0
    @items_in_group = 0
    @items_without_pic = 0
    @items_with_pic = 0
    @avg_pic_size = 0
    @max_pic_size = 0
    @min_pic_size = 0
  end

end
