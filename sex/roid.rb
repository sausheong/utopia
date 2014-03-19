require './base/roid'
class Roid
  attr_reader :energy, :sex, :age, :lifespan

  init_method = instance_method(:initialize)
  define_method :initialize do |world, p, v, uid|
    init_method.bind(self).call world, p, v, uid
    @energy = rand(MAX_ENERGY)
    @sex = rand(2) == 1 ? :male : :female
    @color = BABY_COLOR
    @lifespan = rand(MAX_LIFESPAN)
    @age = 0    
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

  def procreate
    if attractive and @sex == :female
      # check for potential nearby mates
      mates = @world.roids.sort {|a,b| self.distance_from(a) <=> self.distance_from(b)}
      nearby_mates = mates.first MAGIC_NUMBER
      nearby_mates.each do |mate|
        if mate.attractive and mate.sex == :male 
          baby = Roid.new @world, @position, @velocity, 1
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