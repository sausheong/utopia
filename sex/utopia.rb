require './base/utopia'
require './money/food'

class Utopia
  attr_accessor :food, :data

  %w(initialize update draw).each do |method_name|
    original_method = instance_method(method_name.to_sym)
    define_method method_name.to_sym do
      original_method.bind(self).call
      self.send "_#{method_name}"
    end
  end
  
  def _initialize
    @food, @data = [], []
    FOOD_COUNT.times do
      randomly_scatter_food FOOD_PROBABILITY
    end    
  end  
  
  def _update    
    quit if @roids.empty?
    @food.each do |item| item.tick; end
    @roids.each do |roid| 
      roid.tick
    end
    data << [@roids.count{|r| r.sex == :male}, 
             @roids.count{|r| r.sex == :female}, 
             @roids.count{|r| r.age > CHILDBEARING_RANGE.first},
             @roids.size ]
    randomly_scatter_food FOOD_PROBABILITY
  end
  
  def _draw
    @food.each do |item| item.draw; end
  end  

  def randomly_scatter_food(probability)
    if (0..probability).include?(rand(100))
      @food << Food.new(self, random_location)
    end  
  end
  
  def quit
    write_to_file "./results/data/sex.csv", data
    close
  end
end