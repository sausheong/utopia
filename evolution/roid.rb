require './base/roid'
class Roid
  attr_reader :energy, :sex, :age, :lifespan, :metabolism, :vision_range

  init_method = instance_method(:initialize)
  define_method :initialize do |world, p, v, uid|
    init_method.bind(self).call world, p, v, uid
    @energy = rand(MAX_ENERGY)
    @sex = rand(2) == 1 ? :male : :female
    @color = BABY_COLOR
    @lifespan = rand(MAX_LIFESPAN)
    @age = 0    
    @metabolism = rand(MAX_METABOLISM*10.0)/10.0
    @vision_range = rand(MAX_VISION_RANGE*10.0)/10.0    
  end
  
  # get attracted to food
  # changed here to include vision range (was previously fixed)
  def behavior_hungry
    @world.food.each do |food|
      if distance_from_point(food.position) < (food.quantity + @vision_range)
        @delta -= self.position - food.position
      end  
      if distance_from_point(food.position) <= food.quantity + 5
        eat food
      end  
    end            
  end

  # consume the food and replenish energy with it
  # changed here to include metabolism (was previously fixed)
  def eat(food)
    food.eat 1
    @energy += @metabolism
  end

  # lose energy at every tick
  def lose_energy
    @energy -= 1
  end

  # called at every tick of time
  def tick
    lose_energy
    grow_older
    procreate
    if @energy <= 0 or @age > @lifespan
      @world.roids.delete self
    end    
  end
  
  #
  def reduce_energy_from_childbirth
    @energy = @energy * CHILDBEARING_ENERGY_SAP
  end
  
  def grow_older
    @age += 1
    if @age > CHILDBEARING_RANGE.first
      @color = @sex == :male ? MALE_COLOR : ROID_COLOR
    end
  end

  # new method - inherit from parents
  def inherit(crossover)
    @metabolism = crossover[0]
    @vision_range = crossover[1]
  end

  # changed here to inherit traits from parents
  def procreate
    if attractive and @sex == :female
      # check for potential nearby mates
      mates = @world.roids.sort {|a,b| self.distance_from(a) <=> self.distance_from(b)}
      nearby_mates = mates.first MAGIC_NUMBER
      nearby_mates.each do |mate|
        if mate.attractive and mate.sex == :male
          baby = Roid.new @world, @position, @velocity, 1
          crossovers = [[@metabolism, @vision_range],
                        [@metabolism,mate.vision_range],
                        [mate.metabolism, @vision_range],
                        [mate.metabolism,mate.vision_range]]
          baby.inherit crossovers[rand(4)]
          @world.roids << baby
          reduce_energy_from_childbirth and mate.reduce_energy_from_childbirth
        end
        
      end      
    end
  end

  def attractive
    CHILDBEARING_RANGE.include? @age and @energy > CHILDBEARING_ENERGY_LEVEL
  end    
end