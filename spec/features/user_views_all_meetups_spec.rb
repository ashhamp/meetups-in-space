require 'spec_helper'

feature "User visits home page" do




  scenario "succefully sees list of meetups" do

    user = User.create(
    provider: "github",
    uid: "1",
    username: "jarlax1",
    email: "jarlax1@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
    meetup = Meetup.create(
    name: "launchers who lunch",
    description: "eating in chinatown",
    location: "chinatown",
    user_id: User.find_by(username: "jarlax1").id
    )
    visit '/meetups'
    binding.pry

    expect(page).to have_content "launchers who lunch"
  end


end
