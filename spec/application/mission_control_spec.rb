require 'rspec'
require_relative '../../lib/domain/position'
require_relative '../../lib/domain/direction'
require_relative '../../lib/domain/plateau'
require_relative '../../lib/domain/rover'
require_relative '../../lib/utils/colorize'
require_relative '../../lib/application/mission_control'

RSpec.describe MissionControl do
  describe '#initialize' do
    it 'raises error when input is nil' do
      expect { MissionControl.new(nil) }.to raise_error(ArgumentError, "Input cannot be nil")
    end

    it 'strips whitespace from input lines' do
      mission = MissionControl.new("5 5  \n  1 2 N  \n  LMLM  ")
      expect(mission.instance_variable_get(:@input_lines)).to eq(['5 5', '1 2 N', 'LMLM'])
    end
  end

  describe '#execute' do
    context 'with valid input' do
      it 'processes single rover correctly' do
        input = "5 5\n1 2 N\nLMLMLMLMM"
        mission = MissionControl.new(input)
        expect(mission.execute).to eq(['1 3 N'])
      end

      it 'processes multiple rovers correctly' do
        input = "5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM"
        mission = MissionControl.new(input)
        expect(mission.execute).to eq(['1 3 N', '5 1 E'])
      end
    end

    context 'with invalid input' do
      it 'raises error for empty input' do
        expect {
          MissionControl.new('').execute
        }.to raise_error(ArgumentError, "Input cannot be empty")
      end

      it 'raises error for insufficient lines' do
        expect {
          MissionControl.new("5 5\n1 2 N").execute
        }.to raise_error(ArgumentError, /not enough lines/)
      end

      it 'raises error for invalid plateau coordinates' do
        expect {
          MissionControl.new("A 5\n1 2 N\nLMLM").execute
        }.to raise_error(ArgumentError, /First line must be plateau coordinates/)
      end

      it 'raises error for invalid rover position' do
        expect {
          MissionControl.new("5 5\n1 2 X\nLMLM").execute
        }.to raise_error(ArgumentError, /Invalid position format/)
      end

      it 'raises error for invalid commands' do
        expect {
          MissionControl.new("5 5\n1 2 N\nLMXLM").execute
        }.to raise_error(ArgumentError, /Invalid command format/)
      end

      it 'raises error for position outside plateau' do
        expect {
          MissionControl.new("5 5\n6 6 N\nLMLM").execute
        }.to raise_error(ArgumentError, /Error with Rover #1/)
      end
    end
  end

  describe 'processing multiple rovers' do
    let(:input) { "5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM" }
    let(:mission) { MissionControl.new(input) }

    it 'processes each rover in sequence' do
      results = mission.execute
      expect(results.length).to eq(2)
      expect(results.first).to eq('1 3 N')
      expect(results.last).to eq('5 1 E')
    end

    it 'maintains correct plateau boundaries for all rovers' do
      results = mission.execute
      results.each do |position|
        x, y, = position.split
        expect(x.to_i).to be_between(0, 5)
        expect(y.to_i).to be_between(0, 5)
      end
    end
  end
end