class BattingPerformance < ActiveRecord::Base
  # Without at least the player_uid we can't associate Players to
  # BattingPerformances, so we at a minimum require this field
  validates :player_uid, presence:true

  belongs_to :player, foreign_key: :player_uid, primary_key: :player_uid
end
