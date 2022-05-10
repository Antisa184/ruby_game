require 'rspec'
require 'spec_helper'
describe 'NPC' do
  before do
    @enemy = NPC::Enemy.new
    @player = Player::Base.new
  end

  context 'when enemy deals damage to player' do
    it 'deals 8 damage' do
      expect(@enemy.deal_damage(@player, false)).to eq(8)
    end
    it 'deals 3 damage' do
      expect(@enemy.deal_damage(@player, true)).to eq(3)
    end
  end

  context 'when enemy takes damage' do
    it 'take 3 damage' do
      expect(@enemy.take_damage(5)).to eq(3)
    end
    before(:example) do
      @enemy.take_damage(100)
    end
    it 'dies' do
      expect(@enemy.health).to eq(0)
      expect(@enemy.is_dead).to eq(true)
    end
  end
  #ENEMYBOSS SAME AS ENEMY
  #SHOP AND QUESTGIVER NOTHING TO TEST

end