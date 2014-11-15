require 'thor'
require 'spaux'

class Spaux
  class CLI < Thor
    desc 'whatever', 'just print whatever'
    def whatever
      puts Spaux.new.whatever
    end
  end
end
