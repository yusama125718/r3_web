class Match < ApplicationRecord
  belongs_to :season
  
  def self.ransackable_associations(auth_object = nil)
    []
  end
  def self.ransackable_attributes(auth_object = nil)
    ["redname1", "redname2", "bluename1", "bluename2", "winner1", "winner2", "is_single", "hopping_allowed", "game_double", "game_boundaries", "game_ex_speed", "score_max"]
  end
end
