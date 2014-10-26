class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :player_uid # I'm naming this player_uid so as not to intefere
                           # with ActiveRecord naming conventions
      t.integer :birth_year
      t.string :first_name
      t.string :last_name
    end
  end
end
