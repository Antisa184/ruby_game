require 'rspec'
require 'spec_helper'

describe 'Player::Base' do
  before do
    @player = Player::Base.new("Player", 1, 0,100, 5, 2, 0, 0, false, [], Inventory::Base.new(10, [], 100, 123), nil, [], nil, "P", "asdf", Player::Stats.new, 123)
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
      @weapon=Item::Weapon.new("Weapon", "Desc", 100, true, false, 1, "Weapon", 1, false, 10, 1, 123)

      @player.equip_weapon(@weapon)
    end
    context 'when req_lvl met' do
      it 'has new weapon equipped' do
        expect(@player.equipped_weapon).to eq(@weapon)
      end
    end
    context 'when req_lvl high' do
      before(:example) do
        @prompt = TTY::Prompt.new
        @weapon_high=Item::Weapon.new("Weapon", "Desc", 100, true, false, 1, "Weapon", 1, false, 10, 3, 123)
      end
      it 'returns message' do
        expect{@player.equip_weapon(@weapon_high)}.to output("You need to be level "+@weapon_high.req_lvl.to_s+" to use this weapon.\n").to_stdout
      end
    end
  end

end