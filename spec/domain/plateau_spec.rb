require 'rspec'
require_relative '../../lib/domain/plateau'
require_relative '../../lib/domain/position'
require_relative '../../lib/utils/colorize'

RSpec.describe Plateau do
  describe "#initialize" do
    it "creates a plateau with valid upper-right coordinates" do
      plateau = Plateau.new(5, 3)  # Changed to show rectangular shape
      expect(plateau.max_x).to eq(5)
      expect(plateau.max_y).to eq(3)
    end

    it "raises error for negative x coordinate" do
      expect { Plateau.new(-1, 3) }.to raise_error(ArgumentError, "Max X must be a positive integer")
    end

    it "raises error for negative y coordinate" do
      expect { Plateau.new(5, -1) }.to raise_error(ArgumentError, "Max Y must be a positive integer")
    end

    it "raises error for non-integer x coordinate" do
      expect { Plateau.new(5.5, 3) }.to raise_error(ArgumentError, "Max X must be a positive integer")
    end

    it "raises error for non-integer y coordinate" do
      expect { Plateau.new(5, 3.5) }.to raise_error(ArgumentError, "Max Y must be a positive integer")
    end
  end

  describe "#contains?" do
    let(:plateau) { Plateau.new(5, 3) }  # Rectangular plateau

    it "returns true for position within bounds" do
      position = Position.new(3, 2)
      expect(plateau.contains?(position)).to be true
    end

    it "returns true for position at origin" do
      position = Position.new(0, 0)
      expect(plateau.contains?(position)).to be true
    end

    it "returns true for position at max x" do
      position = Position.new(5, 2)
      expect(plateau.contains?(position)).to be true
    end

    it "returns true for position at max y" do
      position = Position.new(3, 3)
      expect(plateau.contains?(position)).to be true
    end

    it "returns false for position beyond max x" do
      position = Position.new(6, 2)
      expect(plateau.contains?(position)).to be false
    end

    it "returns false for position beyond max y" do
      position = Position.new(3, 4)
      expect(plateau.contains?(position)).to be false
    end

    it "returns false for negative position" do
      position = Position.new(-1, -1)
      expect(plateau.contains?(position)).to be false
    end
  end

  describe "edge cases" do
    it "handles minimum size plateau" do
      plateau = Plateau.new(0, 0)
      position = Position.new(0, 0)
      expect(plateau.contains?(position)).to be true
    end

    it "validates boundaries precisely" do
      plateau = Plateau.new(1, 1)
      expect(plateau.contains?(Position.new(1, 1))).to be true
      expect(plateau.contains?(Position.new(1, 2))).to be false
      expect(plateau.contains?(Position.new(2, 1))).to be false
    end
  end
end