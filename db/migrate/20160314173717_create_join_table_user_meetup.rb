class CreateJoinTableUserMeetup < ActiveRecord::Migration
  def change
    create_join_table :users, :meetups do |t|
      t.index [:user_id, :meetup_id]
      t.index [:meetup_id, :user_id]
    end
  end
end
