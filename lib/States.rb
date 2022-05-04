module States
  class Base
    def self.inside_margin?(x, y)
      x>=0 and x<Map::Base.height and y>=0 and y<Map::Base.width
    end
    def self.special_char?(x, y)
      "▓░©®EĐ€Q".include? Map::Base.entire_map[x][y]
    end
    def self.main_menu(player)
      prompt=TTY::Prompt.new
      choices = %w(Inventory Back Exit)
      results = prompt.select("__Menu__", choices)
      if results=='Back'
      elsif results=='Exit'
        puts 'Exiting'
        exit
      elsif results=='Inventory'
        return Game.open_inventory(player)
      end
    end

    def self.near_object(x, y)
      if inside_margin?(x, y) and special_char?(x,y)
        Map::Base.objects.each do |o|
          if o[1]==x and o[2]==y
            if @@object_count==1 then puts "To interact with object press the corresponding function key." end
            puts "F"+@@object_count.to_s+" "+o[0].name.to_s+" Type: "+o[0].class.to_s
            @@objects_near.append(o)
            return true
          end
        end
      end
    end

    def self.game(player)

      #RENDER MAP
      puts Map::Base.render(player)

      #####CHECK IF PLAYER NEAR OBJECTS
      @@object_count=1
      @@objects_near=[]
      if near_object(player.pos_x-1, player.pos_y) then @@object_count+=1 end
      if near_object(player.pos_x+1, player.pos_y) then @@object_count+=1 end
      if near_object(player.pos_x, player.pos_y-1) then @@object_count+=1 end
      if near_object(player.pos_x, player.pos_y+1) then @@object_count+=1 end

    end

    def self.objects_near
      @@objects_near
    end
  end
end
