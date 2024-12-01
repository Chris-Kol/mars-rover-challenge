require 'rspec'
require_relative '../../lib/domain/position'
require_relative '../../lib/domain/direction'
require_relative '../../lib/domain/plateau'
require_relative '../../lib/domain/rover'
require_relative '../../lib/utils/colorize'

RSpec.describe Rover do
  let(:plateau) { Plateau.new(5, 5) }
  let(:position) { Position.new(1, 2) }
  let(:direction) { Direction.new('N') }

  describe "#initialize" do
    it "creates a rover with valid inputs" do
      rover = Rover.new(position, direction, plateau)
      expect(rover.position).to eq(position)
      expect(rover.direction).to eq(direction)
    end

    it "raises error for invalid position type" do
      expect {
        Rover.new("invalid", direction, plateau)
      }.to raise_error(ArgumentError, "Position must be a Position object")
    end

    it "raises error for invalid direction type" do
      expect {
        Rover.new(position, "invalid", plateau)
      }.to raise_error(ArgumentError, "Direction must be a Direction object")
    end

    it "raises error for invalid plateau type" do
      expect {
        Rover.new(position, direction, "invalid")
      }.to raise_error(ArgumentError, "Plateau must be a Plateau object")
    end

    it "raises error for position outside plateau" do
      invalid_position = Position.new(6, 6)
      expect {
        Rover.new(invalid_position, direction, plateau)
      }.to raise_error(ArgumentError, "Initial position must be within plateau")
    end
  end

  describe "#execute_command" do
    let(:rover) { Rover.new(position, direction, plateau) }

    context "turning" do
      it "turns left correctly" do
        rover.execute_command('L')
        expect(rover.direction.facing).to eq('W')
      end

      it "turns right correctly" do
        rover.execute_command('R')
        expect(rover.direction.facing).to eq('E')
      end
    end

    context "moving" do
      it "moves north correctly" do
        rover.execute_command('M')
        expect(rover.position.y).to eq(3)
        expect(rover.position.x).to eq(1)
      end

      it "doesn't move beyond plateau boundaries" do
        edge_position = Position.new(5, 5)
        edge_rover = Rover.new(edge_position, Direction.new('N'), plateau)
        edge_rover.execute_command('M')
        expect(edge_rover.position.y).to eq(5)
      end
    end

    it "raises error for invalid command" do
      rover = Rover.new(position, direction, plateau)
      expect { rover.execute_command('X') }.to raise_error(ArgumentError, rover.red("Invalid command: X"))
    end
  end

  describe "complex movements" do
    it "handles long command sequences" do
      rover = Rover.new(Position.new(0, 0), Direction.new('N'), Plateau.new(5, 5))
      commands = "MMRMMLM"
      commands.each_char { |cmd| rover.execute_command(cmd) }
      expect(rover.to_s).to eq("2 3 N")
    end

    it "completes a square movement pattern" do
      rover = Rover.new(Position.new(2, 2), Direction.new('N'), Plateau.new(5, 5))
      commands = "MRMRMRMR"
      commands.each_char { |cmd| rover.execute_command(cmd) }
      expect(rover.to_s).to eq("2 2 N")
    end
  end

  describe "edge cases" do
    it "handles repetitive commands" do
      rover = Rover.new(Position.new(2, 2), Direction.new('N'), Plateau.new(5, 5))
      5.times { rover.execute_command('M') }
      expect(rover.position.y).to eq(5)
    end

    it "maintains orientation when blocked" do
      rover = Rover.new(Position.new(0, 0), Direction.new('N'), Plateau.new(1, 1))
      rover.execute_command('M')
      rover.execute_command('M')
      expect(rover.direction.facing).to eq('N')
    end
  end

  describe "#to_s" do
    it "returns string representation of rover's state" do
      rover = Rover.new(position, direction, plateau)
      expect(rover.to_s).to eq("1 2 N")
    end
  end
end