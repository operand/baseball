require 'spec_helper'

describe BattingPerformance do
  it "is invalid without a player_uid" do
    bp = BattingPerformance.new
    expect(bp).to_not be_valid
    expect(bp.errors[:player_uid]).to be_present
  end

  # Okay this is basically just testing ActiveRecord, but I wanted to make sure
  # I set up the associations correctly.
  it "belongs_to player" do
    player = Player.create!(player_uid:'foo')
    batting_performance = BattingPerformance.create!(player_uid:'foo')
    expect(batting_performance.reload.player).to eq player
  end
end
