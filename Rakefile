require_relative "baseball"

def import_csv_file(filename, csv_options, klass, field_map)
  CSV.foreach(filename, csv_options) do |csv_row|
    model = klass.new
    field_map.each do |csv_field_name, model_field_name|
      model.send("#{model_field_name}=", csv_row[csv_field_name])
    end
    begin
      model.save!
    rescue ActiveRecord::RecordInvalid => e
      warn "Could not save invalid model: #{model.errors.full_messages}"
    end
  end
end

desc "Initializes the application"
task :setup => [:run_migrations, :import_csvs]

desc "Imports the CSV's"
task :import_csvs do
  puts "importing data..."
  import_csv_file(
    "csv/Master-small.csv",
    {headers:true},
    Player,
    {
      'playerID'  => :player_uid,
      'birthYear' => :birth_year,
      'nameFirst' => :first_name,
      'nameLast'  => :last_name,
    }
  )
  import_csv_file(
    "csv/Batting-07-12.csv",
    {headers:true},
    BattingPerformance,
    {
      'playerID' => :player_uid,
      'yearID'   => :year_id,
      'league'   => :league,
      'teamID'   => :team_id,
      'G'        => :games_played,
      'AB'       => :at_bats,
      'R'        => :runs,
      'H'        => :hits,
      '2B'       => :doubles,
      '3B'       => :triples,
      'HR'       => :homeruns,
      'RBI'      => :runs_batted_in,
      'SB'       => :stolen_bases,
      'CS'       => :caught_stealing,
    }
  )

  puts "imported #{Player.count} players."
  puts "imported #{BattingPerformance.count} batting performances."
end

desc "Deletes and recreates the db"
task :reset_db => [:delete_db, :run_migrations]

desc "Deletes the db files"
task :delete_db do
  sh "rm db/*.db"
end

desc "Runs migrations"
task :run_migrations do
  puts "running migrations..."
  ActiveRecord::Migrator.migrate(:migrations)
end

desc "Calculates results and writes them to STDOUT"
task :run do
  calculator = Calculator.new
  writer = Writer.new(
    $stdout,
    Calculator.new,
    [
      :most_improved_batting_average_from_2009_to_2010,
      :slugging_percentage_for_oakland_players_in_2007,
      :al_and_nl_triple_crown_winner_for_2011_and_2012,
    ]
  )
  writer.output
end

desc "Start a console session with the app loaded"
task :console do
  puts "opening console..."
  sh "irb -rubygems -r './baseball.rb'"
end
