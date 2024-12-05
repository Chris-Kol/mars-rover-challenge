require 'rspec'
require_relative '../../lib/domain/direction'
require_relative '../../lib/utils/colorize'

RSpec.describe Direction do
  describe "#initialize" do
    it "creates a direction with valid cardinal point" do
      direction = Direction.new('N')
      expect(direction.facing).to eq('N')
    end

    it "raises error for invalid direction" do
      expect { Direction.new('X') }.to raise_error(ArgumentError, "Invalid direction")
    end
  end

  describe "#turn_left" do
    it "turns left from North to West" do
      direction = Direction.new('N')
      expect(direction.turn_left.facing).to eq('W')
    end

    it "turns left from West to South" do
      direction = Direction.new('W')
      expect(direction.turn_left.facing).to eq('S')
    end

    it "turns left from South to East" do
      direction = Direction.new('S')
      expect(direction.turn_left.facing).to eq('E')
    end

    it "turns left from East to North" do
      direction = Direction.new('E')
      expect(direction.turn_left.facing).to eq('N')
    end
  end

  describe "#turn_right" do
    it "turns right from North to East" do
      direction = Direction.new('N')
      expect(direction.turn_right.facing).to eq('E')
    end

    it "turns right from East to South" do
      direction = Direction.new('E')
      expect(direction.turn_right.facing).to eq('S')
    end

    it "turns right from South to West" do
      direction = Direction.new('S')
      expect(direction.turn_right.facing).to eq('W')
    end

    it "turns right from West to North" do
      direction = Direction.new('W')
      expect(direction.turn_right.facing).to eq('N')
    end
  end

  describe "edge cases" do
    it "handles multiple full rotations" do
      direction = Direction.new('N')
      8.times { direction = direction.turn_right }
      expect(direction.facing).to eq('N')
    end
  end

  describe "#to_s" do
    it "returns the direction as a string" do
      direction = Direction.new('N')
      expect(direction.to_s).to eq('N')
    end
  end
end