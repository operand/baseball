require 'spec_helper'

describe Calculator do
  describe "#most_improved_batting_average_from_2009_to_2010" do
    it "calculates correctly" do
      steady_player  = Player.create!(player_uid:'steady_player')
      improved_player = Player.create!(player_uid:'improved_player')
      improved_player_with_few_at_bats = Player.create!(player_uid:'improved_player_with_few_at_bats')

      BattingPerformance.create!(
        player_uid:'steady_player',
        year_id: 2009,
        at_bats: 200,
        hits: 100
      )
      BattingPerformance.create!(
        player_uid:'steady_player',
        year_id: 2010,
        at_bats: 200,
        hits: 100
      )
      BattingPerformance.create!(
        player_uid:'improved_player',
        year_id: 2009,
        at_bats: 200,
        hits: 100
      )
      BattingPerformance.create!(
        player_uid:'improved_player',
        year_id: 2010,
        at_bats: 200,
        hits: 200
      )
      BattingPerformance.create!(
        player_uid:'improved_player_with_few_at_bats',
        year_id: 2009,
        at_bats: 100,
        hits: 0
      )
      BattingPerformance.create!(
        player_uid:'improved_player_with_few_at_bats',
        year_id: 2010,
        at_bats: 100,
        hits: 100
      )

      expect(subject.most_improved_batting_average_from_2009_to_2010).to eq({
        'player_uid'        => 'improved_player',
        'avg_2009'          => 0.5,
        'avg_2010'          => 1.0,
        'batting_avg_delta' => 0.5
      })
    end
  end

  describe "#slugging_percentage_for_oakland_players_in_2007" do
    it "calculates correctly" do
      player1 = Player.create!(player_uid:'player1')
      player2 = Player.create!(player_uid:'player2')
      player3 = Player.create!(player_uid:'player3')
      player4 = Player.create!(player_uid:'player4')

      BattingPerformance.create!(
        player_uid: 'player1',
        year_id: 2007,
        team_id: 'OAK',
        at_bats: 100,
        hits: 10,
        doubles: 2,
        triples: 3,
        homeruns: 4
      ) # should be a slugging percentage of 0.3 if I calculated correctly
      BattingPerformance.create!(
        player_uid: 'player2',
        year_id: 2007,
        team_id: 'OAK',
        at_bats: 100,
        hits: 10,
        doubles: 4,
        triples: 3,
        homeruns: 2
      ) # should be a slugging percentage of 0.26 if I calculated correctly
      BattingPerformance.create!(
        player_uid: 'player3',
        year_id: 2007,
        team_id: 'ABC',
        at_bats: 100,
        hits: 10,
        doubles: 4,
        triples: 3,
        homeruns: 2
      ) # this guy shouldn't be included, because he's not on OAK
      BattingPerformance.create!(
        player_uid: 'player4',
        year_id: 2008,
        team_id: 'OAK',
        at_bats: 100,
        hits: 10,
        doubles: 4,
        triples: 3,
        homeruns: 2
      ) # this performance shouldn't be included, because it's not from 2007

      expect(subject.slugging_percentage_for_oakland_players_in_2007).to eq([
        {'player_uid' => 'player1', 'slugging_percentage' => 0.3},
        {'player_uid' => 'player2', 'slugging_percentage' => 0.26},
      ])
    end
  end

  describe "#al_and_nl_triple_crown_winner_for_2011_and_2012" do
    it "calculates correctly" do
      player1 = Player.create!(player_uid:'player1')
      player2 = Player.create!(player_uid:'player2')

      # a simple setup for a triple crown winner in AL 2011
      BattingPerformance.create!(
        player_uid: 'player1',
        year_id: 2011,
        league: 'AL',
        hits: 100,
        at_bats: 400,
        homeruns: 10,
        runs_batted_in: 10,
      )

      # a setup for no triple crown winner in NL, 2011
      BattingPerformance.create!(
        player_uid: 'player1',
        year_id: 2011,
        league: 'NL',
        hits: 100,
        at_bats: 400,
        homeruns: 10,
        runs_batted_in: 11, # player1 did better on runs_batted_in
      )
      BattingPerformance.create!(
        player_uid: 'player2',
        year_id: 2011,
        league: 'NL',
        hits: 101, # player2 did better on hits
        at_bats: 400,
        homeruns: 10,
        runs_batted_in: 10,
      )

      # another setup for no triple crown winner in AL, 2012
      BattingPerformance.create!(
        player_uid: 'player1',
        year_id: 2012,
        league: 'AL',
        hits: 101, # player1 did better on hits
        at_bats: 400,
        homeruns: 10,
        runs_batted_in: 10,
      )
      BattingPerformance.create!(
        player_uid: 'player2',
        year_id: 2012,
        league: 'AL',
        hits: 100,
        at_bats: 400,
        homeruns: 11, # player2 did better on homeruns
        runs_batted_in: 10,
      )

      # NL triple crown winner 2012
      BattingPerformance.create!(
        player_uid: 'player1',
        year_id: 2012,
        league: 'NL',
        hits: 101,
        at_bats: 400,
        homeruns: 10,
        runs_batted_in: 10,
      )
      BattingPerformance.create!(
        player_uid: 'player2',
        year_id: 2012,
        league: 'NL',
        hits: 100,
        at_bats: 400,
        homeruns: 10,
        runs_batted_in: 10,
      )

      expect(subject.al_and_nl_triple_crown_winner_for_2011_and_2012).to eq({
        'al_triple_crown_winner_2011' => player1,
        'nl_triple_crown_winner_2011' => nil,
        'al_triple_crown_winner_2012' => nil,
        'nl_triple_crown_winner_2012' => player1,
      })
    end
  end
end
