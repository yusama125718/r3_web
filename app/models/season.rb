class Season < ApplicationRecord
  has_many :matches
  has_many :users

  def new_season(name="")
    Season.transaction do
      seasons = Season.all
      if !seasons.blank?
        seasons.each do |season|
          if season.finished_at.nil?
            season.finished_at = Time.now
            season.save!
          end
        end
      end
      Season.create!(name: name)
    end
  end
end
