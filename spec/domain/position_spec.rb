require 'rspec'
require_relative '../../lib/domain/position'
require_relative '../../lib/utils/colorize'

RSpec.describe Position do
  describe "#initialize" do
    it "creates a position with valid integer coordinates" do
      position = Position.new(1, 2)
      expect(position.x).to eq(1)
      expect(position.y).to eq(2)
    end

    it "raises error for non-integer x" do
      expect { Position.new(1.5, 2) }.to raise_error(ArgumentError, "X must be an integer")
      expect { Position.new("1", 2) }.to raise_error(ArgumentError, "X must be an integer")
    end

    it "raises error for non-integer y" do
      expect { Position.new(1, 2.5) }.to raise_error(ArgumentError, "Y must be an integer")
      expect { Position.new(1, "2") }.to raise_error(ArgumentError, "Y must be an integer")
    end
  end

  describe "movements" do
    let(:position) { Position.new(1, 1) }

    describe "#move" do
      it "creates new position with offset coordinates" do
        new_position = position.move(2, 3)
        expect(new_position.x).to eq(3)
        expect(new_position.y).to eq(4)
      end

      it "raises error for non-integer movements" do
        expect { position.move(1.5, 0) }.to raise_error(ArgumentError, "DX must be an integer")
        expect { position.move(0, 1.5) }.to raise_error(ArgumentError, "DY must be an integer")
      end
    end

    it "moves north correctly" do
      new_position = position.move_north
      expect(new_position.x).to eq(1)
      expect(new_position.y).to eq(2)
    end

    it "moves south correctly" do
      new_position = position.move_south
      expect(new_position.x).to eq(1)
      expect(new_position.y).to eq(0)
    end

    it "moves east correctly" do
      new_position = position.move_east
      expect(new_position.x).to eq(2)
      expect(new_position.y).to eq(1)
    end

    it "moves west correctly" do
      new_position = position.move_west
      expect(new_position.x).to eq(0)
      expect(new_position.y).to eq(1)
    end
  end

  describe "edge cases" do
    it "handles large integer values" do
      big_number = 1_000_000
      position = Position.new(big_number, big_number)
      expect(position.x).to eq(big_number)
      expect(position.y).to eq(big_number)
    end
  end
end