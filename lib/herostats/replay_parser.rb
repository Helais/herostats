require 'tempfile'

class ReplayParser
  PROTOCOL_LOCATION = 'heroprotocol/heroprotocol.py'

  # Returns a Game from a parse .StormReplay file
  def self.parse(path)
    test = File.dirname(__FILE__) + '/../heroprotocol/heroprotocol.py'


    #return unless File.exist?(path)
    init_data        = Tempfile.new('initdata.json')
    tracker_events  = Tempfile.new('trackerevents.json')
    system "python #{test} --initdata --json \"#{path}\" > #{init_data.path}"
    system "python #{test} --trackerevents --json \"#{path}\" > #{tracker_events.path}"

    game = Game.new
    game = InitDataParser.new(game).parse(init_data)
    game = TrackerEventsParser.new(game).parse(tracker_events)

    previous = 0
    points = []
    #puts game.blue_team.exp_breakdowns.map { |e|  e.total_exp }.join(',')
    game.red_team.exp_breakdowns.each do |b|

      points.push(b.total_exp - previous)
      previous = b.total_exp
    end

    game
  end
end

# ReplayParser.parse('/Users/ronaldleask/Desktop/Battlefield of Eternity (23).StormReplay')
