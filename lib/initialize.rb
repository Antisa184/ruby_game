module Initialize
  class Base
    def self.to_bool(state)
      if state=="true"
        return true
      else
        return false
      end
    end
    def self.load_quests(objects, file, sep)
      file.each do |line|
        lineSplit = line.split(sep)
        objects.append(Quest::Base.new(lineSplit[0], lineSplit[1], lineSplit[2].split(" "), lineSplit[3].to_i, lineSplit[4].to_i))
      end
      return objects
    end
    def self.load_items(objects, file, sep)
      file.each do |line|
        lineSplit = line.split(sep)
        if lineSplit[6]=="Consumable"
          objects.append(Item::Consumable.new(lineSplit[0], lineSplit[1],lineSplit[2].to_i, Initialize::Base.to_bool(lineSplit[3]), Initialize::Base.to_bool(lineSplit[4]), lineSplit[5].to_i, lineSplit[6], lineSplit[7].to_i, Initialize::Base.to_bool(lineSplit[8]), lineSplit[9], lineSplit[10].to_i))
        elsif lineSplit[6]=="Weapon"
          objects.append(Item::Weapon.new(lineSplit[0], lineSplit[1],lineSplit[2].to_i, Initialize::Base.to_bool(lineSplit[3]), Initialize::Base.to_bool(lineSplit[4]), lineSplit[5].to_i, lineSplit[6], lineSplit[7].to_i, Initialize::Base.to_bool(lineSplit[8]), lineSplit[9].to_i, lineSplit[10].to_i, lineSplit[11].to_i))
        end
      end
      return objects
    end
    def self.load_npcs(objects, file)
      file.each do |line|
        lineSplit = line.split(";")
        if lineSplit[0]=="Enemy" or lineSplit[0]=="EnemyBoss"
          items=lineSplit[7].split("|")
          enemy_inventory=Initialize::Base.load_items([], items, ",")
          if lineSplit[0]=="Enemy"
            objects.append(NPC::Enemy.new(lineSplit[1], lineSplit[2].to_i, lineSplit[3].to_i, lineSplit[4].to_i, lineSplit[5].to_i, lineSplit[6].to_i, Inventory::Base.new(lineSplit[7].to_i,enemy_inventory, lineSplit[9].to_i, lineSplit[10].to_i), Initialize::Base.to_bool(lineSplit[11]), lineSplit[12], lineSplit[13], lineSplit[14].to_i))
          else
            objects.append(NPC::EnemyBoss.new(lineSplit[1], lineSplit[2].to_i, lineSplit[3].to_i, lineSplit[4].to_i, lineSplit[5].to_i, lineSplit[6].to_i, Inventory::Base.new(lineSplit[7].to_i,enemy_inventory, lineSplit[9].to_i, lineSplit[10].to_i), Initialize::Base.to_bool(lineSplit[11]), lineSplit[12], lineSplit[13], lineSplit[14].to_i))
          end
        elsif lineSplit[0]=="Shop"
          items=lineSplit[5].split("|")
          enemy_inventory=Initialize::Base.load_items([], items, ",")
          objects.append(NPC::Shop.new(lineSplit[1], lineSplit[2].to_i, lineSplit[3].to_i, Inventory::Base.new(lineSplit[4].to_i, enemy_inventory, lineSplit[5].to_i, lineSplit[6].to_i), lineSplit[7].to_i))
        elsif lineSplit[0]=="QuestGiver"
          items=lineSplit[4].split("|")
          quests=Initialize::Base.load_quests([], items, ",")
          objects.append(NPC::QuestGiver.new(lineSplit[1], lineSplit[2].to_i, lineSplit[3].to_i, quests, lineSplit[5].to_i))
        end
      end
      return objects
    end
    def self.load_abilities(objects, file)
      file.each do |line|
        lineSplit = line.split(",")
        ability=Abilities::Base.new(lineSplit[0], lineSplit[1].to_i,lineSplit[2][0...-1])
        objects.append(ability)
      end
      objects
    end
    def self.determine_level(xp)
      File.open(File.join(Dir.pwd,"/data/levels")).each do |line|
        if xp<line.split(",")[0].to_i then return line.split(",")[1].to_i end
      end
    end
    def self.get_objects
      objects=[]

      #LOAD ITEMS
      objects=Initialize::Base.load_items(objects, File.open(File.join(Dir.pwd,"/data/Items")),";")
      #LOAD NPCS
      objects=Initialize::Base.load_npcs(objects, File.open(File.join(Dir.pwd, "/data/NPCs")))
      #RETURN OBJECTS
      objects
    end
    def self.setup_map(objects)

      #CREATE AND DRAW MAP
      map_file=File.open(File.join(Dir.pwd,"/data/Map")).readlines
      Map::Base.new("mapa", map_file[0].size, map_file.size, [], nil)
      Map::Base.load_map(map_file)

      #PUTTING OBJECTS ON THE MAP
      objects.each do |item|
        if item.is_a?(NPC::Enemy) or item.is_a?(NPC::EnemyBoss) or item.is_a?(NPC::Shop) or item.is_a?(NPC::QuestGiver)
          x=item.pos_x.to_i
          y=item.pos_y.to_i
        else
          x=rand(0...Map::Base.height)
          y=rand(0...Map::Base.width)
        end
        Map::Base.add_object(item, x, y)
      end

      #TEST OBJECTS
      Map::Base.add_object(Item::Weapon.new("Common Dagger", "Small knife", 50, true, false, 1, "Weapon", 1, false, 20, 1, 2), 5,7)
      Map::Base.add_object(NPC::Enemy.new("Đuro", 25, 15, 5, 2, 35, Inventory::Base.new(10, [], 20, 1234), false, "E", "asdf", 3), 5, 5)
      Map::Base.add_object(Item::Consumable.new("Small Health potion", "Restores 30 HP", 25, true, true, 2, "Consumable", 1, false, "Restore 30 HP",1), 6, 6)

    end
  end
end