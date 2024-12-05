require 'rspec'
require_relative '../../lib/domain/position'
require_relative '../../lib/domain/direction'
require_relative '../../lib/domain/plateau'
require_relative '../../lib/domain/rover'
require_relative '../../lib/utils/colorize'
require_relative '../../lib/application/mission_control'

RSpec.describe MissionControl do
  # Helper method to capture stdout
  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = StringIO.new
    block.call
    $stdout.string
  ensure
    $stdout = original_stdout
  end

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

        # Only capture output when specifically testing it
        result = capture_stdout { mission.execute }
        expect(result).to include("Mission completed successfully!")
      end

      it 'processes multiple rovers correctly' do
        input = "5 5\n1 2 N\nLMLMLMLMM\n3 3 E\nMMRMMRMRRM"
        mission = MissionControl.new(input)
        results = nil

        # Suppress standard output for this test
        expect {
          results = mission.execute
        }.to output.to_stdout

        expect(results).to eq(['1 3 N', '5 1 E'])
      end

      it 'displays appropriate progress messages' do
        input = "5 5\n1 2 N\nLMLMLMLMM"
        mission = MissionControl.new(input)

        output = capture_stdout { mission.execute }

        expect(output).to include("Starting Mars Rover Mission")
        expect(output).to include("Deploying Rover #1")
        expect(output).to include("Mission completed successfully!")
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
end