class UserInfo < ApplicationRecord
  has_many :users
  has_many :name_histories, dependent: :destroy
end
