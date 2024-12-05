require_relative '../utils/colorize'

class MissionControl
  include Colorize

  def initialize(input)
    raise ArgumentError, "Input cannot be nil" if input.nil?
    @input_lines = input.strip.split("\n").map(&:strip)
  end

  def execute
    puts blue("\n🛸 Starting Mars Rover Mission...")
    validate_input
    create_plateau
    results = process_rovers
    puts green("\n✅ Mission completed successfully!")
    results
  end

  private

  def validate_input
    validate_input_length
    validate_input_structure
  end

  def validate_input_length
    if @input_lines.empty?
      raise ArgumentError, "Input cannot be empty"
    end

    if @input_lines.length < 3
      raise ArgumentError, "Invalid input: not enough lines. Minimum required: 3 lines (plateau coordinates + rover position + commands)"
    end

    if @input_lines.length.even?
      raise ArgumentError, "Invalid input: incomplete rover instructions. Each rover needs both position and command lines"
    end
  end

  def validate_input_structure
    unless @input_lines.first =~ /^\d+\s\d+$/
      raise ArgumentError, "First line must be plateau coordinates (e.g., '5 5')"
    end

    # Check rover input pairs
    rover_lines = @input_lines[1..]
    rover_lines.each_slice(2).with_index do |(position, commands), index|
      unless position =~ /^\d+\s\d+\s[NSEW]$/
        raise ArgumentError, "Invalid position format for rover #{index + 1}. Expected 'X Y Direction' (e.g., '1 2 N')"
      end

      unless commands && commands =~ /^[LRM]+$/
        raise ArgumentError, "Invalid command format for rover #{index + 1}. Only L, R, M commands are allowed"
      end
    end
  end

  def create_plateau
    max_x, max_y = @input_lines.shift.split.map(&:to_i)
    @plateau = Plateau.new(max_x, max_y)
  rescue ArgumentError => e
    raise ArgumentError, "Invalid plateau coordinates: #{e.message}"
  end

  def process_rovers
    @rovers = []
    rover_number = 1

    while @input_lines.any?
      puts blue("\n🤖 Deploying Rover ##{rover_number}...")

      position_line = @input_lines.shift
      command_line = @input_lines.shift

      rover = create_and_move_rover(position_line, command_line, rover_number)

      puts green("Rover ##{rover_number} completed its mission!")
      print_rover_status(rover, rover_number)

      @rovers << rover
      rover_number += 1
    end

    @rovers.map(&:to_s)
  end

  def create_and_move_rover(position_line, command_line, rover_number)
    x, y, direction = position_line.split
    position = Position.new(x.to_i, y.to_i)
    direction = Direction.new(direction)
    rover = Rover.new(position, direction, @plateau)

    puts yellow("Initial position: #{position_line}")
    puts yellow("Commands: #{command_line}")

    command_line.each_char { |command| rover.execute_command(command) }
    rover
  rescue ArgumentError => e
    raise ArgumentError, "Error with Rover ##{rover_number}: #{e.message}"
  end

  def print_rover_status(rover, rover_number)
    puts yellow("\nCommand History for Rover ##{rover_number}:")
    rover.command_status.each { |status| puts "  #{status}" }
    puts blue("Final position: #{rover}")
  end
end