class Player


  attr_accessor :hero, :name, :talents, :kills, :assists, :deaths, :siege_damage, :hero_damage, :damage_taken, :healing, :exp

  def initialize
    @talents = []
    @kills = 0
    @regen_globes = 0
  end

  def pickup_regen_globe
    @regen_globes += 1
  end

  def select_talent(talent)
    @talents.push(talent)
  end

  def role_stat
    return healing unless healing == 0
    return damage_taken unless damage_taken == 0
    nil
  end
end