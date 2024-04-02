class UserInfo < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :name_histories, dependent: :destroy
end
