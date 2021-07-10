module Roro

  class CLI < Thor

    desc 'rollyourown', "Roll your own RoRo development story."

    map 'roll_your_own' => 'roll_your_own'

    def roll_your_own
      @config = Roro::Configurators::Configurator.new
      @config.choose_your_adventure
    end
  end
end
