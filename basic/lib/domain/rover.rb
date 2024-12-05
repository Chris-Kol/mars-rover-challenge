require_relative '../utils/colorize'
require_relative 'warnings/plateau_boundary_warning'

class Rover
  include Colorize
  attr_reader :position, :direction, :command_status

  def initialize(position, direction, plateau)
    raise ArgumentError, "Position must be a Position object" unless position.is_a?(Position)
    raise ArgumentError, "Direction must be a Direction object" unless direction.is_a?(Direction)
    raise ArgumentError, "Plateau must be a Plateau object" unless plateau.is_a?(Plateau)
    raise ArgumentError, "Initial position must be within plateau" unless plateau.contains?(position)

    @position = position
    @direction = direction
    @plateau = plateau
    @command_status = []
  end

  def execute_command(command)
    case command
    when 'L'
      @direction = direction.turn_left
      @command_status << green("Turned left successfully")
    when 'R'
      @direction = direction.turn_right
      @command_status << green("Turned right successfully")
    when 'M'
      move_forward
    else
      raise ArgumentError, red("Invalid command: #{command}")
    end
  end

  def to_s
    "#{position.x} #{position.y} #{direction.facing}"
  end

  private

  def move_forward
    new_position = case direction.facing
    when 'N'
      Position.new(position.x, position.y + 1)
    when 'E'
      Position.new(position.x + 1, position.y)
    when 'S'
      Position.new(position.x, position.y - 1)
    when 'W'
      Position.new(position.x - 1, position.y)
    end

    if @plateau.contains?(new_position)
      @position = new_position
      @command_status << "Moved to position #{@position}"
    else
      warn PlateauBoundaryWarning.for_position(new_position)
      @command_status << "Movement blocked: position #{new_position} is outside plateau"
    end
  end
end