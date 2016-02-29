require 'herostats/version'

Gem.find_files('herostats/**/*.rb').each { |path| require path }

module Herostats
  def self.parse(file_path)
    ReplayParser.parse(file_path)
  end
end

