require 'rspec'
require 'spec_helper'

describe 'Map' do
  before do
    @map=Map::Base.new
  end

  context 'when change_pixel' do
    before(:example) do
      Map::Base.change_pixel(0,0,"P")
    end
    it 'changes pixel at 0,0 to P' do
      expect(Map::Base.entire_map[0][0]).to eq("P")
    end
  end

  context 'when add_object Consumable to 0,0' do
    before(:example) do
      Map::Base.add_object(Item::Consumable.new,0,0)
    end
    it 'changes pixel at 0,0 to ▓' do
      expect(Map::Base.entire_map[0][0]).to eq("▓")
    end
  end

  context 'when add_object Consumable to invalid position' do
    it 'returns message' do
      expect{Map::Base.add_object(Item::Consumable.new,-1,-1)}.to output("Position out of bounds!\n").to_stdout
    end
  end

  context 'when check_collision with item' do
    before(:example) do
      Map::Base.add_object(Item::Consumable.new,0,0)
    end
    it 'changes pixel at 0,0 to ▓' do
      expect(Map::Base.check_collision(0,0)).to eq(true)
    end
  end

  context 'when render player at 0,0' do
    before(:example) do
      @player=Player::Base.new
    end
    it 'changes pixel at 0,0 to ▓' do
      expect(Map::Base.render(@player)[0][0]).to eq(@player.map_marker)
    end
  end

end