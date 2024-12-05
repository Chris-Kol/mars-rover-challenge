class Direction
  DIRECTIONS = ['N', 'E', 'S', 'W'].freeze

  attr_reader :facing

  def initialize(direction)
    @facing = direction.to_s.upcase
    raise ArgumentError, "Invalid direction" unless DIRECTIONS.include?(@facing)
  end

  def turn_left
    current_index = DIRECTIONS.index(@facing)
    new_index = (current_index - 1) % 4
    Direction.new(DIRECTIONS[new_index])
  end

  def turn_right
    current_index = DIRECTIONS.index(@facing)
    new_index = (current_index + 1) % 4
    Direction.new(DIRECTIONS[new_index])
  end

  def to_s
    @facing
  end
end