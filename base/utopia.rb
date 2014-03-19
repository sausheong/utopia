include Gosu

class Utopia < Window
  include Logger
  
  attr_accessor :roids, :canvas
  
  def initialize
    super WORLD[:xmax], WORLD[:ymax], false
    self.caption = "Utopia"
    @background = Gosu::Image.new(self, BACKGROUND, true)    
    @time = 0
    @roids = []
    POPULATION_SIZE.times do |count|
      @roids << Roid.new(self, random_location, random_velocity, count)     
    end    
  end
  
  def update
    self.caption = "Utopia - #{END_OF_THE_WORLD - @time}"
    @roids.each do |roid| roid.move; end
    @time += 1
    quit if @time > END_OF_THE_WORLD
  end
  
  def draw
    @background.draw 0,0,0
    @roids.each do |roid| roid.draw; end    
  end

  def random_location
    Vector[rand(WORLD[:xmax]),rand(WORLD[:ymax])]
  end  
  
  def random_velocity
    Vector[rand(ROID_SIZE), rand(ROID_SIZE)]
  end
  
  def quit
    close
  end
end
