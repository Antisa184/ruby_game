require 'rspec'
require 'spec_helper'
describe 'NPC' do
  before do
    @enemy = NPC::Enemy.new
    @enemyBoss = NPC::EnemyBoss.new
    @shop = NPC::Shop.new
    @questgiver = NPC::QuestGiver.new
    @player = Player::Base.new
    @quest = Quest::Base.new
  end

  context 'when enemy deals damage to player' do
    it 'deals 8 damage' do
      expect(@enemy.deal_damage(@player, false)).to eq(8)
    end
  end

  context 'when enemy takes damage' do
    it 'take 3 damage' do
      expect(@enemy.take_damage(5)).to eq(3)
    end
  end
  #ENEMYBOSS SAME AS ENEMY
  #SHOP AND QUESTGIVER NOTHING TO TEST

end