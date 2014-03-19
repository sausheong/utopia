ROID_SIZE = 5
ROID_COLOR = Gosu::Color::YELLOW

WORLD = {xmax: ROID_SIZE * 100, ymax: ROID_SIZE * 100} # boundary of the world
BACKGROUND = "#{File.dirname(__FILE__)}/backgrounds/red_paper.jpg"
POPULATION_SIZE = 60
MAGIC_NUMBER = 10 # the number of roids it will monitor

SEPARATION_RADIUS = ROID_SIZE * 2 # steer to avoid crowding of flockmates
ALIGNMENT_RADIUS  = ROID_SIZE * 35 # steer towards average heading of flockmates
COHESION_RADIUS   = ROID_SIZE * 35 # steer to move toward average position of flockmates

SEPARATION_ADJUSTMENT = 10 # how far away should roids stay from each other (small further away)
ALIGNMENT_ADJUSTMENT = 8 # how aligned are the roids with each other (smaller more aligned)
COHESION_ADJUSTMENT = 100 # how cohesive the roids are with each other (smaller more cohesive)
CENTER_RADIUS = ROID_SIZE * 20 # radius of how close to the center it stays
MAX_ROID_SPEED = 15

END_OF_THE_WORLD = 2000