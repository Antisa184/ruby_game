require 'rspec'
require 'spec_helper'

describe 'States' do
  before do
    @map = Map::Base.new
    @item = Item::Consumable.new
  end

  context 'check if position inside_margin' do
    it 'returns true' do
      expect(States::Base.inside_margin?(1,1)).to eq(true)
    end
    it 'returns false' do
      expect(States::Base.inside_margin?(-1,0)).to eq(false)
    end
  end

  context 'check if object at position' do
    before(:example) do
      Map::Base.add_object(@item, 0, 0)
    end
    it 'returns true' do
      expect(States::Base.special_char?(0,0)).to eq(true)
    end
    it 'returns false' do
      expect(States::Base.special_char?(1,0)).to eq(false)
    end
  end
end