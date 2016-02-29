class Game
  # An Hash of Player in the current game
  attr_accessor :players
  # An Hash of Team in the current game
  attr_accessor :teams
  def initialize
    @players = {}
    @teams = {1 => Team.new, 2 => Team.new}
  end

  # Adds a player to the
  # @param
  def add_player(player)
    @players[@players.count + 1] = player
  end

  # Alias for team 1
  def blue_team
    teams[1]
  end
  # Alias for team 2
  def red_team
    teams[2]
  end
end