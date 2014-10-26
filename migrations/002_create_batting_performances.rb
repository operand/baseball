class CreateBattingPerformances < ActiveRecord::Migration
  def change
    create_table :batting_performances do |t|
      t.string :player_uid
      t.integer :year_id
      t.string :league
      t.string :team_id
      t.integer :games_played
      t.integer :at_bats
      t.integer :runs
      t.integer :hits
      t.integer :doubles
      t.integer :triples
      t.integer :homeruns
      t.integer :runs_batted_in
      t.integer :stolen_bases
      t.integer :caught_stealing
    end
  end
end
