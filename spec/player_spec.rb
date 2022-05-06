require 'rspec'
require 'spec_helper'

describe 'Player::Base' do
  before do
    @map = Map::Base.new("Map", 71, 30, [], 1, 123)
    @entire_map="'':.:'':.:'':.:'':.:'':.:'':.:'':.:'':.:'':.:''**:'':.:'':.:'':.:888888
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
    @entire_map=@entire_map.split("\n")
    Map::Base.load_map(@entire_map)
    @player = Player::Base.new
  end

  after do
    # Do nothing
  end

  context 'when gain_xp' do
    before(:example) do
      @player.gain_xp(30)
    end
    it 'changes xp value' do
      expect(@player.xp).to eq(30)
    end
  end

  context 'when gain_gold' do
    before(:example) do
      @player.gain_gold(30)
    end
    it 'changes gold value' do
      expect(@player.inventory.gold).to eq(130)
    end
  end

  context 'when lose_gold' do
    before(:example) do
      @player.lose_gold(30)
    end
    it 'changes gold value' do
      expect(@player.inventory.gold).to eq(70)
    end
  end

  context 'when equip_weapon' do
    before(:example) do
      @weapon=Item::Weapon.new

      @player.equip_weapon(@weapon)
    end
    context 'when req_lvl met' do
      it 'has new weapon equipped' do
        expect(@player.equipped_weapon).to eq(@weapon)
      end
    end
    context 'when req_lvl high' do
      before(:example) do
        @weapon_high=Item::Weapon.new
        @weapon_high.req_lvl=3
      end
      it 'returns message' do
        expect{@player.equip_weapon(@weapon_high)}.to output("You need to be level "+@weapon_high.req_lvl.to_s+" to use this weapon.\n").to_stdout
      end
    end
  end

  context 'when take_item' do
    before(:example) do
      @item = Item::Base.new
      @player.take_item(@item)
    end
    it 'has 1 item in inventory' do
      expect(@player.inventory.slots.size).to eq(1)
    end
  end

  context 'when move_to' do
    context 'when position valid' do
      before(:example) do
        @player.move_to(1,1)
      end
      it 'moves to position' do
        expect(@player.pos_x).to eq(1)
        expect(@player.pos_y).to eq(1)
      end
    end
    context 'when position invalid' do
      before(:example) do
        @player.move_to(-1,-1)
      end
      it 'moves to position' do
        expect(@player.pos_x).to eq(0)
        expect(@player.pos_y).to eq(0)
      end
    end

  end
  context 'when accept_quest' do
    before (:example) do
      @quest = Quest::Base.new
      @player.accept_quest(@quest)
    end
    it 'has 1 quest in Quests' do
      expect(@player.quests.size).to eq(1)
    end
  end

  context 'when take_damage' do
    before (:example) do
      @player.take_damage(30)
    end
    it 'takes damage' do
      expect(@player.health).to eq(70)
    end
  end

  context 'when deal_damage' do
    before (:example) do
      @enemy=NPC::Enemy.new
    end
    it 'takes damage' do
      expect(@player.deal_damage(@enemy)).to eq(3)
    end
  end

  context 'when accept_quest' do
    before (:example) do
      @quest = Quest::Base.new
      @player.accept_quest(@quest)
    end
    it 'has 1 quest in Quests' do
      expect(@player.quests.size).to eq(1)
    end
  end

  context 'when dead and check is_dead' do
    before(:example) do
      @player.take_damage(120)
    end
    it 'returns true' do
      expect(@player.is_dead).to eq(true)
    end
  end

  context 'when add_ability' do
    before (:example) do
      @ability = Abilities::Base.new
      @player.add_ability(@ability)
    end
    it 'has 1 quest in Quests' do
      expect(@player.abilities.size).to eq(1)
    end
  end
end