require 'spec_helper'

describe Player do
  it "is invalid without a player_uid" do
    player = Player.new
    expect(player).to_not be_valid
    expect(player.errors[:player_uid]).to be_present
  end

  # Okay this is basically just testing ActiveRecord, but I wanted to make sure
  # I set up the associations correctly.
  it "has_many batting_performances" do
    player = Player.create!(player_uid:'foo')
    batting_performance = BattingPerformance.create!(player_uid:'foo')
    expect(player.reload.batting_performances.count).to eq 1
  end
end
