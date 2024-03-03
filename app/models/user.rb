class User < ApplicationRecord
  belongs_to :season
  belongs_to :user_info
end
