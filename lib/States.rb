module States
  class Base
    def self.main_menu
      prompt=TTY::Prompt.new
      choices = %w(Inventory Back Exit)
      results = prompt.multi_select("__Menu__", choices)
      if results.first()=='Back'
      elsif results.first()=='Exit'
        puts 'Exiting'
        exit
      elsif results.first()=='Inventory'
      end
    end
    def self.game
      puts Map::Base.render
    end
  end
end
