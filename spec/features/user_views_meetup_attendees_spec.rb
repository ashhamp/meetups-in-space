require 'spec_helper'
require 'pry'

feature "User views a meetups attendees" do

  scenario "user views a meetups attendees" do

    user1 = User.create(
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

    user3 = User.create(
    provider: "github",
    uid: "3",
    username: "ashhamp",
    email: "ashhamp@launchacademy.com",
    avatar_url: "http://data.whicdn.com/images/3025923/large.jpg"
    )

    meetup1 = Meetup.create(
    name: "launchers who lunch",
    description: "eating in chinatown",
    location: "chinatown",
    creator: user1
    )

    join1 = MeetupsUser.create(
      user: user2,
      meetup: meetup1
    )

    join2 = MeetupsUser.create(
      user: user3,
      meetup: meetup1
    )

    visit '/meetups'
    click_on (meetup1.name)

    expect(page).to have_content (user2.username)
    expect(page).to have_content (user3.username)
    page.should have_css("img",  "http://orig13.deviantart.net/2e80/f/2011/072/e/8/harry_potter_avatar_by_the_authoress124-d3bjr9y.png")
    page.should have_css("img",  "http://data.whicdn.com/images/3025923/large.jpg")

    end
  end
