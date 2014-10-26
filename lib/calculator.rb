class Calculator

  def most_improved_batting_average_from_2009_to_2010
    sql = <<-SQL
      SELECT
        players.*,
        (performance_2009.hits*1.0/performance_2009.at_bats) as avg_2009,
        (performance_2010.hits*1.0/performance_2010.at_bats) as avg_2010,
        (
          (performance_2010.hits*1.0/performance_2010.at_bats) -
          (performance_2009.hits*1.0/performance_2009.at_bats)
        ) as batting_avg_delta
      FROM
        players
        JOIN (
          SELECT *
          FROM batting_performances
          WHERE year_id = 2009
          AND at_bats >= 200
        ) as performance_2009
        ON players.player_uid = performance_2009.player_uid
        JOIN (
          SELECT *
          FROM batting_performances
          WHERE year_id = 2010
          AND at_bats >= 200
        ) as performance_2010
        ON players.player_uid = performance_2010.player_uid
      ORDER BY
        batting_avg_delta DESC
      LIMIT 1
    SQL
    result = Player.find_by_sql(sql).first
    result.attributes.slice(
      'player_uid',
      'avg_2009',
      'avg_2010',
      'batting_avg_delta',
    )
  end

  def slugging_percentage_for_oakland_players_in_2007
    sql = <<-SQL
      SELECT
        players.*,
        (
          (
            1.0 *
            (hits - doubles - triples - homeruns) +
            (2 * doubles) +
            (3 * triples) +
            (4 * homeruns)
          ) / at_bats
        ) as slugging_percentage
      FROM
        players
        JOIN batting_performances
        ON players.player_uid = batting_performances.player_uid
      WHERE
        batting_performances.team_id = 'OAK'
        AND year_id = 2007
    SQL
    results = Player.find_by_sql(sql)
    results.map do |result|
      result.attributes.slice('player_uid', 'slugging_percentage')
    end
  end

  def al_and_nl_triple_crown_winner_for_2011_and_2012
    results = {}
    results['al_triple_crown_winner_2011'] = triple_crown_winner('2011', 'AL')
    results['nl_triple_crown_winner_2011'] = triple_crown_winner('2011', 'NL')
    results['al_triple_crown_winner_2012'] = triple_crown_winner('2012', 'AL')
    results['nl_triple_crown_winner_2012'] = triple_crown_winner('2012', 'NL')
    results
  end

  private

  def triple_crown_winner(year, league)
    sql = <<-SQL
      SELECT
        players.*
      FROM
        players
        /*
          Join on batting performances for the chosen league/year where there
          were at least 400 at bats
        */
        JOIN (
          SELECT *
          FROM batting_performances bp_inner
          WHERE bp_inner.year_id = #{year}
          AND bp_inner.league = '#{league}'
          AND bp_inner.at_bats >= 400
        ) as bp
        ON players.player_uid = bp.player_uid
      WHERE
        /*
          Here we check the conditions that there are no other players
          in that league/year with better hitting stats, who also had at least
          400 at bats.
        */
        NOT EXISTS (
          SELECT *
          FROM batting_performances bp2
          WHERE
            bp2.league = bp.league
            AND bp2.year_id = bp.year_id
            AND bp2.at_bats >= 400
            AND (
              bp2.homeruns > bp.homeruns
              OR bp2.runs_batted_in > bp.runs_batted_in
              OR (1.0*bp2.hits/bp2.at_bats) > (1.0*bp.hits/bp.at_bats)
            )
        )
      LIMIT 1
    SQL
    result = Player.find_by_sql(sql)
    result.first
  end

end
