# An ExpBreakdown represents a collection of experience sources for a given minute of game time for a team
class ExpBreakdown
  #
  attr_accessor :creep
  attr_accessor :hero
  attr_accessor :minion
  attr_accessor :structure
  attr_accessor :trickle
  attr_accessor :time

  def initialize(minion, creep, structure, hero, trickle, time)
    @minion = minion
    @creep = creep
    @structure = structure
    @hero = hero
    @trickle = trickle
    @time = time
  end

  # Returns the total experience for this breakdown
  def total_exp
    @minion + @creep + @structure + @hero + @trickle
  end
end