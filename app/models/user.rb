class User < ApplicationRecord
  belongs_to :season
  belongs_to :user_info

  def self.ransackable_associations(auth_object = nil)
    []
  end
  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
