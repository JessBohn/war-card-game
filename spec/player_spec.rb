# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/card'

RSpec.describe Player do
  let(:card1) { Card.new('A', 'Hearts') }
  let(:card2) { Card.new('2', 'Diamonds') }
  let(:cards) { [card1, card2] }
  let(:player) { Player.new('Jessica', cards) }

  it 'has a name' do
    expect(player.name).to eq('Jessica')
  end

  it 'has a hand of cards' do
    expect(player.hand.all?(Card)).to be true
  end

  it 'can draw a card' do
    drawn_card = player.draw_card
    expect(drawn_card).to be_a(Card)
    expect(player.hand).to eq(cards - [drawn_card])
  end

  context 'player takes cards from pile' do
    let(:card3) { Card.new(3, 'Diamonds') }
    let(:card4) { Card.new(4, 'Clubs') }
    it 'can add cards to hand' do
      player.add_cards([card3, card4])
      expect(player.hand).to eq([card1, card2, card3, card4])
    end
  end

  context 'a player with no cards' do
    let(:empty_player) { Player.new('Bob', []) }

    it 'is out of cards' do
      expect(empty_player.out_of_cards?).to be true
    end

    it 'cannot draw a card' do
      expect(empty_player.draw_card).to be_nil
    end
  end
end
