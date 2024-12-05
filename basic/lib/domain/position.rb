class Position
  attr_reader :x, :y

  def initialize(x, y)
    raise ArgumentError, "X must be an integer" unless x.is_a?(Integer)
    raise ArgumentError, "Y must be an integer" unless y.is_a?(Integer)
    @x = x
    @y = y
  end

  def move(dx, dy)
    raise ArgumentError, "DX must be an integer" unless dx.is_a?(Integer)
    raise ArgumentError, "DY must be an integer" unless dy.is_a?(Integer)
    Position.new(x + dx, y + dy)
  end

  def move_north
    move(0, 1)
  end

  def move_south
    move(0, -1)
  end

  def move_east
    move(1, 0)
  end

  def move_west
    move(-1, 0)
  end

  def to_s
    "#{@x} #{@y}"
  end
end