class Roid
  attr_reader :velocity, :position, :uid, :color

  def initialize(world, p, v, uid)    
    @velocity = v # assume v is a Vector with X velocity and Y velocity as elements
    @position = p # assume p is a Vector with X and Y as elements
    @world = world
    @uid = uid
    @color = ROID_COLOR
  end

  def distance_from(roid)
    distance_from_point(roid.position)
  end

  def distance_from_point(vector)
    x = self.position[0] - vector[0]
    y = self.position[1] - vector[1]
    Math.sqrt(x*x + y*y)    
  end

  def nearby?(threshold, roid)
    return false if roid === self
    (distance_from(roid) < threshold)
  end

  # draw the roid
  def draw
    @world.draw_quad(@position[0], @position[1], @color, 
                     @position[0] + ROID_SIZE, @position[1], @color, 
                     @position[0] - @velocity[0], @position[1] - @velocity[1], @color, 
                     @position[0] - @velocity[0] + ROID_SIZE, @position[1] - @velocity[1], @color, 
                     1) 
  end

  # move the roid
  def move
    @delta = Vector[0,0]    
    %w(separate align cohere muffle center).each do |action|
      self.send action
    end    
    
    methods.find_all {|name| name.to_s.start_with? "behavior_"}.each do |behavior|
      self.send behavior
    end
    @velocity += @delta
    @position += @velocity
    fallthrough  
  end

  # roids should not be too close to each other
  def separate
    distance = Vector[0,0]
    r = @world.roids.sort {|a,b| self.distance_from(a) <=> self.distance_from(b)}
    roids = r.first(MAGIC_NUMBER)
      roids.each do |roid|
        if nearby?(SEPARATION_RADIUS, roid)
          distance += self.position - roid.position
        end    
      end
    @delta += distance
  end

  # roids should look out for roids near it and then fly towards the center of where the rest are flying
  def align
    alignment = Vector[0,0]
    r = @world.roids.sort {|a,b| self.distance_from(a) <=> self.distance_from(b)}
    roids = r.first(MAGIC_NUMBER)
    roids.each do |roid|
      alignment += roid.velocity
    end
    alignment /= MAGIC_NUMBER
    @delta += alignment/ALIGNMENT_ADJUSTMENT
  end

  # roids should stick to each other
  def cohere
    average_position = Vector[0,0]
    r = @world.roids.sort {|a,b| self.distance_from(a) <=> self.distance_from(b)}
    roids = r.first(MAGIC_NUMBER)
    roids.each do |roid|
      average_position += roid.position
    end
    average_position /= MAGIC_NUMBER
    @delta +=  (average_position - @position)/COHESION_ADJUSTMENT
  end

  
  # muffle the speed of the roid to dampen the swing
  # swing causes the roid to move too quickly out of range to be affected by the rules
  def muffle
    if @velocity.r > MAX_ROID_SPEED
      @velocity /= @velocity.r 
      @velocity *= MAX_ROID_SPEED  
    end
  end

  # get the roids to move around the center of the displayed world
  def center
    @delta -= (@position - Vector[WORLD[:xmax]/2, WORLD[:ymax]/2]) / CENTER_RADIUS
  end

  def fallthrough
    x = case 
    when @position[0] < 0            then WORLD[:xmax] + @position[0]
    when @position[0] > WORLD[:xmax] then WORLD[:xmax] - @position[0]
    else @position[0]
    end
    y = case 
    when @position[1] < 0            then WORLD[:ymax] + @position[1]
    when @position[1] > WORLD[:ymax] then WORLD[:ymax] - @position[1]
    else @position[1]
    end 
    @position = Vector[x,y]    
  end


end