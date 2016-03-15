class Meetup < ActiveRecord::Base
  belongs_to :creator, class_name: :User
  has_many :meetups_users
  has_many :users, through: :meetups_users

end
