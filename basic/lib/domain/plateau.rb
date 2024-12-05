class Plateau
  attr_reader :max_x, :max_y

  def initialize(max_x, max_y)
    raise ArgumentError, "Max X must be a positive integer" unless max_x.is_a?(Integer) && max_x >= 0
    raise ArgumentError, "Max Y must be a positive integer" unless max_y.is_a?(Integer) && max_y >= 0
    @max_x = max_x
    @max_y = max_y
  end

  def contains?(position)
    raise ArgumentError, "Position must be a Position object" unless position.is_a?(Position)
    position.x >= 0 && position.x <= max_x &&
    position.y >= 0 && position.y <= max_y
  end
end