require 'spec_helper'
require 'pry'

feature "User can use a meetup" do

  scenario "signed in user succesfully joins meetup" do

    user = User.create(
    provider: "github",
    uid: "1",
    username: "jarlax1",
    email: "jarlax1@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )

    user2 = User.create(
    provider: "github",
    uid: "2",
    username: "jennga",
    email: "jennga@launchacademy.com",
    avatar_url: "http://orig13.deviantart.net/2e80/f/2011/072/e/8/harry_potter_avatar_by_the_authoress124-d3bjr9y.png"
    )

    meetup1 = Meetup.create(
    name: "launchers who lunch",
    description: "eating in chinatown",
    location: "chinatown",
    creator: user
    )

    visit '/'
    sign_in_as user2
    click_on (meetup1.name)
    click_on "Join Group"

    expect(page).to have_content(meetup1.name)
    expect(page).to have_content(user2.username)
    expect(page).to have_content("You've joined!")

  end
  scenario "not signed in user sees sign in prompt" do

    user = User.create(
    provider: "github",
    uid: "1",
    username: "jarlax1",
    email: "jarlax1@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )

    user2 = User.create(
    provider: "github",
    uid: "2",
    username: "jennga",
    email: "jennga@launchacademy.com",
    avatar_url: "http://orig13.deviantart.net/2e80/f/2011/072/e/8/harry_potter_avatar_by_the_authoress124-d3bjr9y.png"
    )

    meetup1 = Meetup.create(
    name: "launchers who lunch",
    description: "eating in chinatown",
    location: "chinatown",
    creator: user
    )

    visit '/'
    click_on (meetup1.name)
    click_on "Join Group"

    expect(page).to have_content(meetup1.name)
    expect(page).to have_content("Please sign in to join group")


  end
end
