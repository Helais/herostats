class TrackerEventsParser
  def initialize(game)
    @game = game
  end

  def load_events(file)
    file = file.read
    file = file.gsub("}\n{", "},\n{")
    file = file.gsub("]\n{", "],\n{")
    JSON.parse("[#{file}]")
  end

  #
  def parse(file_path)
    events = load_events(file_path)

    events.each do |event|
      if event['_event'] == 'NNet.Replay.Tracker.SUnitBornEvent'
        #u = Unit.new(event['m_unitTagIndex'],
        #             event['m_unitTagRecycle'],
        #             event['m_controlPlayerId'],
        #             event['_gameloop'],
        #             event['m_x'],
        #             event['m_y]'],
        #             event['m_upkeepPlayerId'],
        #            event['m_unitTypeName'])

        #units[u.id] = u

        #puts "#{u.name} #{u.id}"

      elsif event['_event'] == 'NNet.Replay.Tracker.SStatGameEvent'

        case event['m_eventName']
          when 'RegenGlobePickedUp'
            #game.pickup_regen_globe(event['m_intData'][0]['m_value'])
            #{"_eventid"=>10, "m_stringData"=>nil, "m_intData"=>[{"m_key"=>"PlayerID", "m_value"=>1}], "_event"=>"NNet.Replay.Tracker.SStatGameEvent", "_gameloop"=>1254, "_bits"=>472, "m_eventName"=>"RegenGlobePickedUp", "m_fixedData"=>nil}
          when 'LevelUp'
            #{"_eventid"=>10, "m_stringData"=>nil, "m_intData"=>[{"m_key"=>"PlayerID", "m_value"=>10}, {"m_key"=>"Level", "m_value"=>1}], "_event"=>"NNet.Replay.Tracker.SStatGameEvent", "_gameloop"=>84, "_bits"=>512, "m_eventName"=>"LevelUp", "m_fixedData"=>nil}
            #puts event

          when 'PeriodicXPBreakdown'
            #{"_eventid"=>10, "m_stringData"=>nil, "m_intData"=>[{"m_key"=>"Team", "m_value"=>1}, {"m_key"=>"TeamLevel", "m_value"=>10}], "_event"=>"NNet.Replay.Tracker.SStatGameEvent", "_gameloop"=>7330, "_bits"=>1920, "m_eventName"=>"PeriodicXPBreakdown", "m_fixedData"=>[{"m_key"=>"GameTime", "m_value"=>1720320}, {"m_key"=>"PreviousGameTime", "m_value"=>1474560}, {"m_key"=>"MinionXP", "m_value"=>57368576}, {"m_key"=>"CreepXP", "m_value"=>618496}, {"m_key"=>"StructureXP", "m_value"=>3276800}, {"m_key"=>"HeroXP", "m_value"=>6882750}, {"m_key"=>"TrickleXP", "m_value"=>31539200}]}
            puts event
            team_number = event['m_intData'].detect { |hash| hash['m_key'] == 'Team'}['m_value']
            fixed_data = event['m_fixedData']
            minion_exp = 0
            creep_exp = 0
            structure_exp = 0
            hero_exp = 0
            trickle_exp = 0
            time = 0

            fixed_data.each do |data|
              case data['m_key']
                when 'MinionXP'
                  minion_exp = data['m_value'] / 4096
                when 'CreepXP'
                  creep_exp = data['m_value'] / 4096
                when 'StructureXP'
                  structure_exp = data['m_value'] / 4096
                when 'HeroXP'
                  hero_exp = data['m_value'] / 4096
                when 'TrickleXP'
                  trickle_exp = data['m_value'] / 4096
                when 'GameTime'
                  time = data['m_value'] / 4096
                else
                  puts data
              end
            end

            @game.teams[team_number].exp_breakdowns.push(ExpBreakdown.new(minion_exp, creep_exp, structure_exp, hero_exp, trickle_exp, time))

          when 'GatesOpen'
            #{"_eventid"=>10, "m_stringData"=>nil, "m_intData"=>nil, "_event"=>"NNet.Replay.Tracker.SStatGameEvent", "_gameloop"=>610, "_bits"=>240, "m_eventName"=>"GatesOpen", "m_fixedData"=>nil}
            #puts event
          when 'TalentChosen'
            #{"_eventid"=>10, "m_stringData"=>[{"m_key"=>"PurchaseName", "m_value"=>"GenericTalentBlock"}], "m_intData"=>[{"m_key"=>"PlayerID", "m_value"=>2}], "_event"=>"NNet.Replay.Tracker.SStatGameEvent", "_gameloop"=>522, "_bits"=>776, "m_eventName"=>"TalentChosen", "m_fixedData"=>nil}
            player_number = event['m_intData'].detect { |hash| hash['m_key'] == 'PlayerID'}['m_value']
            talent_name = event['m_stringData'].detect { |hash| hash['m_key'] == 'PurchaseName'}['m_value']
            @game.players[player_number].select_talent(talent_name)
          when 'PlayerDeath'
            #{"_eventid"=>10, "m_stringData"=>nil, "m_intData"=>[{"m_key"=>"PlayerID", "m_value"=>7}, {"m_key"=>"KillingPlayer", "m_value"=>1}, {"m_key"=>"KillingPlayer", "m_value"=>4}, {"m_key"=>"KillingPlayer", "m_value"=>5}], "_event"=>"NNet.Replay.Tracker.SStatGameEvent", "_gameloop"=>2692, "_bits"=>1360, "m_eventName"=>"PlayerDeath", "m_fixedData"=>[{"m_key"=>"PositionX", "m_value"=>549022}, {"m_key"=>"PositionY", "m_value"=>709147}]}
          when 'TownStructureDeath'
            #{"_eventid"=>10, "m_stringData"=>nil, "m_intData"=>[{"m_key"=>"TownID", "m_value"=>9}, {"m_key"=>"KillingPlayer", "m_value"=>1}, {"m_key"=>"KillingPlayer", "m_value"=>2}, {"m_key"=>"KillingPlayer", "m_value"=>4}, {"m_key"=>"KillingPlayer", "m_value"=>5}], "_event"=>"NNet.Replay.Tracker.SStatGameEvent", "_gameloop"=>18584, "_bits"=>1224, "m_eventName"=>"TownStructureDeath", "m_fixedData"=>nil}
          when 'RavenCurseActivated'
            #{"_eventid"=>10, "m_stringData"=>nil, "m_intData"=>[{"m_key"=>"Event", "m_value"=>2}, {"m_key"=>"TeamScore", "m_value"=>3}, {"m_key"=>"OpponentScore", "m_value"=>2}], "_event"=>"NNet.Replay.Tracker.SStatGameEvent", "_gameloop"=>18044, "_bits"=>968, "m_eventName"=>"RavenCurseActivated", "m_fixedData"=>[{"m_key"=>"TeamID", "m_value"=>4096}]}
          when 'TributeCollected'
            #{"_eventid"=>10, "m_stringData"=>nil, "m_intData"=>[{"m_key"=>"Event", "m_value"=>1}], "_event"=>"NNet.Replay.Tracker.SStatGameEvent", "_gameloop"=>4221, "_bits"=>600, "m_eventName"=>"TributeCollected", "m_fixedData"=>[{"m_key"=>"TeamID", "m_value"=>8192}]}

          when 'JungleCampCapture'
            #{"_eventid"=>10, "m_stringData"=>[{"m_key"=>"CampType", "m_value"=>"Bruiser Camp"}], "m_intData"=>[{"m_key"=>"CampID", "m_value"=>2}], "_event"=>"NNet.Replay.Tracker.SStatGameEvent", "_gameloop"=>18252, "_bits"=>872, "m_eventName"=>"JungleCampCapture", "m_fixedData"=>[{"m_key"=>"TeamID", "m_value"=>4096}]}
          else
            #puts event
        end
      elsif event['_event'] == 'NNet.Replay.Tracker.SUnitDiedEvent'
        #puts event
      elsif event['_event'] == 'NNet.Replay.Tracker.SUnitOwnerChangeEvent'
      elsif event['_event'] == 'NNet.Replay.Tracker.SUnitRevivedEvent'

      elsif event['_event'] == 'NNet.Replay.Tracker.SScoreResultEvent'
        event['m_instanceList'].each do |list|
          puts list['m_name']
          case list['m_name']
            when 'SoloKill'
              list['m_values'].each_with_index do |v, index|
                @game.players[index + 1].kills = v[0]['m_value'] unless index > 9
              end
            when 'Deaths'
              list['m_values'].each_with_index do |v, index|
                @game.players[index + 1].deaths = v[0]['m_value'] unless index > 9
              end
            when 'Assists'
              list['m_values'].each_with_index do |v, index|
                @game.players[index + 1].assists = v[0]['m_value'] unless index > 9
              end
            when 'SiegeDamage'
              list['m_values'].each_with_index do |v, index|
                @game.players[index + 1].siege_damage = v[0]['m_value'] unless index > 9
              end
            when 'HeroDamage'
              list['m_values'].each_with_index do |v, index|
                @game.players[index + 1].hero_damage = v[0]['m_value'] unless index > 9
              end
            when 'ExperienceContribution'
              list['m_values'].each_with_index do |v, index|
                @game.players[index + 1].exp = v[0]['m_value'] unless index > 9
              end
            when 'DamageTaken'
              list['m_values'].each_with_index do |v, index|
                @game.players[index + 1].damage_taken = v[0]['m_value'] unless index > 9
              end
            when 'Healing'
              list['m_values'].each_with_index do |v, index|
                #puts v
                @game.players[index + 1].healing = v[0]['m_value'] unless index > 9
              end
            when 'SelfHealing'
              list['m_values'].each_with_index do |v, index|
                #puts v
                #@game.players[index + 1].healing = v[0]['m_value'] unless index > 9
              end
            else
              list['m_values'].each_with_index do |v, index|
                #puts v
              end
          end

        end
        #puts event
      else
        #puts event
      end
    end
    @game
  end
end