class Meetup < ActiveRecord::Base
  
  has_many :users, through: :meetups_users
end
