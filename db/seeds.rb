# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Account.create!(
   name: 'admin',
   password: "hogehoge.rate", 
   password_confirmation: "hogehoge.rate"
)

Season.create!(
   name: 'TestSeason1'
)

# season2 = Season.create!(
#    name: 'Season2'
# )

# info1 = UserInfo.create!(
#    name: 'tanaka'
# )

# NameHistory.create!(
#    name: 'tanaka',
#    user_info: info1
# )

# user1 = User.create!(
#    user_info: info1,
#    name: 'tanaka',
#    season_id: season.id,
#    nw_s_win: 1,
#    nw_s_rate: 50
# )

# User.create!(
#    user_info: info1,
#    name: 'tanaka',
#    season_id: season2.id,
#    nw_s_win: 1,
#    nw_s_rate: 100
# )

# info2 = UserInfo.create!(
#    name: 'takahashi'
# )

# NameHistory.create!(
#    name: 'takahashi',
#    user_info: info2
# )

# user2 = User.create!(
#    user_info: info2,
#    name: 'takahashi',
#    season_id: season.id,
#    nw_s_win: 1,
#    nw_s_rate: 80
# )

# User.create!(
#    user_info: info2,
#    name: 'takahashi',
#    season_id: season2.id,
#    nw_s_win: 1,
#    nw_s_rate: 50
# )

# info3 = UserInfo.create!(
#    name: 'sakamoto'
# )

# NameHistory.create!(
#    name: 'sakamoto',
#    user_info: info1
# )

# user3 = User.create!(
#    user_info: info3,
#    name: 'sakamoto',
#    season_id: season.id,
#    nw_s_win: 1,
#    nw_s_rate: 90
# )

# User.create!(
#    user_info: info3,
#    name: 'sakamoto',
#    season_id: season2.id,
#    nw_s_win: 1,
#    nw_s_rate: 150
# )

# info4 = UserInfo.create!(
#    name: 'oda'
# )

# NameHistory.create!(
#    name: 'oda',
#    user_info: info1
# )

# user4 = User.create!(
#    user_info: info4,
#    name: 'oda',
#    season_id: season.id,
#    nw_s_win: 1,
#    nw_s_rate: 50
# )

# User.create!(
#    user_info: info4,
#    name: 'oda',
#    season_id: season2.id,
#    nw_s_win: 1,
#    nw_s_rate: 30
# )
