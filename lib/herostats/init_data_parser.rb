require 'json'

class InitDataParser
  def initialize(game)
    @game = game
  end

  def load_events(file)
    file = file.read
    file = file.gsub("}\n{", "},\n{")
    file = file.gsub("]\n{", "],\n{")
    JSON.parse("[#{file}]")
  end

  def parse(file)
    events = load_events(file)
    events.each do |event|
      if event.class == Hash

        event['m_syncLobbyState'].each do |k, v|
          #puts v
          case k
            when 'm_userInitialData'
              #{"m_testAuto"=>false, "m_mount"=>"", "m_observe"=>0, "m_teamPreference"=>{"m_team"=>nil}, "m_toonHandle"=>"", "m_customInterface"=>false, "m_highestLeague"=>0, "m_clanTag"=>"", "m_testMap"=>false, "m_clanLogo"=>nil, "m_examine"=>false, "m_testType"=>0, "m_combinedRaceLevels"=>4294967295, "m_randomSeed"=>0, "m_racePreference"=>{"m_race"=>nil}, "m_skin"=>"", "m_hero"=>"", "m_name"=>"Biscuit"}
              v.each do |initial_data|
                player = Player.new
                player.name = initial_data['m_name']
                puts player.name
                @game.add_player(player) unless player.name.empty?
              end
            when 'm_lobbyState'
              v['m_slots'].each_with_index do |slot, index|
                @game.players[index + 1].hero = slot['m_hero'] unless index > 9
                #puts "#{game.players[index].name} #{game.players[index].hero}"
                #puts slot
              end
            when 'm_gameDescription'
          end
        end
      end
    end

    @game
  end
end