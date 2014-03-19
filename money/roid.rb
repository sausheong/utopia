require './base/roid'
class Roid
  attr_reader :energy

  init_method = instance_method(:initialize)
  define_method :initialize do |world, p, v, uid|
    init_method.bind(self).call world, p, v, uid
    @energy = rand(100)
  end
  
  # get attracted to food
  def behavior_hungry
    @world.food.each do |food|
      if distance_from_point(food.position) < (food.quantity + ROID_SIZE*5)
        @delta -= self.position - food.position
      end  
      if distance_from_point(food.position) <= food.quantity + 5
        eat food
      end  
    end    
  end

  # consume the food and replenish energy with it
  def eat(food)
    food.eat 1
    @energy += METABOLISM
  end

  # lose energy at every tick
  def lose_energy
    @energy -= 1
  end

  # called at every tick of time
  def tick
    lose_energy
    if @energy <= 0
      @world.roids.delete self
    end    
  end
end