require 'spec_helper'
require 'pry'

feature "User visits meetups index" do

  scenario "succesfully sees list of all meetups" do

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
    creator: user
    )
    # binding.pry

    visit '/meetups'

    click_on "launchers who lunch"
    expect(page).to have_content (meetup.name)
    expect(page).to have_content (meetup.description)
    expect(page).to have_content (meetup.location)
    expect(page).to have_content (meetup.creator.username)
  end


end
