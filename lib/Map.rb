module Map
  class Base
    @@map="'':.:'':.:'':.:'':.:'':.:'':.:'':.:'':.:'':.:''**:'':.:'':.:'':.:888888
..:':..:':..:':..:':..:':..:':..:':..:':..:'******..:':..:':..:'8888888
'':.:'':.:***.:'':.:'':.:'':.:'':.:'':.:'':*******'':.:'':.:'':88888888
..:':..:'******.**':..:':..:':..:':..:':..********..:':..:':..:88888888
'':.:'':.**********:'':.:'':.:'':.:'':.:*********:'':.:'':.:''8888888:'
..:':..:':**********..:':..:':..:':..:'*******.:':..:':..:':..8888888:.
'':.:'':.:'**********':.:'':.:'':.:'':*********:.:'':.:'':.:'8888888.:'
..:':..:':..:********.:':..:':..:':..:**********':..:':..:':.8888888':.
'':.:'':.:''*********':.:'':.:'':.:'':**********.:'':.:'':.:8888888:.:'
..:':..:':..*********.:':..:':..:':..:'*********':..:':..:_8888888.:':.
'':.:'':.:'':********':.:'':.:'':.:'':.:*******:.:'':.:'_88888888'':.:'
..:'*****************.:':..:':..:':..:':..:':..:':..:_:888888888:..:':.
'':*****************'':.:'':.:'':.:'':.:'':.:'':.:'88888888888888888.:'
..:***************':..:':..:':..:':..:':..:':..:':8888888888888888888:.
'':.*************:.:'':.:'':.:'':.:'':.:'':.:'':.8888888888888888888888
..:'***********..:':..:':..:':..:':..:':..:':..888888888888:..:':888888
'':.***********'':.:'':.:'':.:'':.:'':.:'':.:'88888888888:.:'':.:'88888
..:'***********..:':..:':..:_:..:_:..:_:..:_:88888888888.:':..:':..:888
'':.**********:'':.:'':.:__88888888888888888888888888.:'':.:'':.:'':.88
..:':*********:..:':..:88888888888888888888888888888:':..:':..:':..:':.
'':.:'*********'':.:'_88888888888888888888888888888':.:'':.:'':.:'':.:'
..:':..:':*****..:':8888888888..:':..:':..888888888.:':..:':..:':..:':.
'':.:'':.:*****'':.8888888':.:'':.:'':.:'8888888888':.:'':.:'':.:'':.:'
..:':..:':.****..:8888888..:':..:':..:':8888888888..:':..:':..:':..:':.
'':.:'':.:'****''888888.:'':.:'':.:'':.88888888888'':.:'':.:'':.:'':.:'
..:':..:':..**:.888888:':..:':..:':.8888888888888:..:':..:':..:':..:':.
'':.:'':.:'':.:888888':.:'':.:'':._88888888888888:'':.:'':.:'':.:'':.:'
..:_:..:_:..:8888888..:':..:':..:8888888888888888:..:':..:':..:':..:':.
8888888888888888888:'':.:'':.:''88888888888888888:'':.:'':.:'':.:'':.:'
88888888888888888:':..:':..:':.88888888888888888':..:':..:':..:':..:':."
    @@map=@@map.split("\n")
    @@count=0
    @@id_default=1
    @@instances=[]
    attr_reader :width, :height, :map

    def initialize(name, width, height, objects, out, id = @@id_default)
      @@id=id, @@name=name, @@width=width, @@height=height, @@objects=objects, @@out=out
      if @@id == @@id_default then @@id_default+=1 end
      @@count += 1
      @@instances << self
    end
    def self.all
      @@instances.inspect
    end

    def self.count
      @@count
    end
    def self.entire_map
      @@map
    end
    def self.width
      @@width
    end
    def self.height
      @@height
    end
    def self.objects
      @@objects
    end
    def self.change_pixel(x,y,pixel)
      @@map[x][y]=pixel
    end

    def self.render(pos_x=0, pos_y=0, map_marker)
      x=0, y=0
      if pos_x<10 then x=0
      elsif Map::Base.height-pos_x<10
        x=Map::Base.height-20
      else x=pos_x-9
      end
      if pos_y<10 then y=0
      elsif Map::Base.width-pos_y<10
        y=Map::Base.width-20
      else y=pos_y-9
      end
      #puts x, y
      #puts pos_x, pos_y
      restricted=@@map.map(&:clone)
      restricted[pos_x][pos_y]=map_marker
      restricted=restricted[x,20]
      restricted.each_with_index do |line, index|
        puts line[y,20]
      end
      return
    end
    def self.add_object(object,pos_x, pos_y)
      if pos_x>=0 and pos_y>=0 and pos_x<Map::Base.height and pos_y<Map::Base.width then
        @@objects.append([object, pos_x, pos_y])
        if object.is_a?(Item::Consumable) then
          @@map[pos_x][pos_y]="▓"
        elsif object.is_a?(Item::Weapon)
          @@map[pos_x][pos_y]="░"
        elsif object.is_a?(NPC::Enemy)
          @@map[pos_x][pos_y]=object.map_marker
        elsif object.is_a?(NPC::EnemyBoss)
          @@map[pos_x][pos_y]=object.map_marker
        end
      end
    end
    def self.display(object)

    end
    def self.remove_object(object)

    end
    def self.check_collision(pos_x, pos_y)
      return "▓░©®EĐ".include?(@@map[pos_x][pos_y])
    end

  end
end
