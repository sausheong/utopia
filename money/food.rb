class Food
  attr_reader :quantity, :position 

  def initialize(world, p)
    @position = p 
    @world = world
    @quantity = rand(RANDOM_FOOD_QUANTITY) + MIN_FOOD_QUANTITY
  end
  
  def eat(much)
    @quantity -= much
  end
  
  def draw
    @world.draw_quad(@position[0], @position[1], FOOD_COLOR, 
                     @position[0] + @quantity, @position[1], FOOD_COLOR, 
                     @position[0], @position[1] + @quantity, FOOD_COLOR, 
                     @position[0] + @quantity, @position[1] + @quantity, FOOD_COLOR, 
                     1)
  end  
  
  def tick
    if @quantity <= 0
      @world.food.delete self
    end
    draw
  end
end