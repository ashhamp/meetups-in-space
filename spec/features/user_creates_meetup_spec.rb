require 'spec_helper'
require 'pry'

feature "User can add new meetup if signed in" do

  scenario "signed in user succesfully creates new meetup" do

    user = User.create(
    provider: "github",
    uid: "1",
    username: "jarlax1",
    email: "jarlax1@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )

    meetup1 = Meetup.create(
    name: "launchers who lunch",
    description: "eating in chinatown",
    location: "chinatown",
    creator: user
    )

    visit '/'
    sign_in_as user


    click_on "Create a New Meetup"


    fill_in "name", with: "Dumbledore's Army"
    fill_in "description", with: "underground defense against the dark arts"
    fill_in "location", with: "room of requirement"

    click_on "Submit"


    expect(page).to have_content "Dumbledore's Army"
    expect(page).to have_content "Event created!"
    expect(page).to_not have_content "launchers who lunch"

  end

  scenario "user not signed in, raises sign in error, redirects to form with prefilled fields" do
    user = User.create(
    provider: "github",
    uid: "1",
    username: "jarlax1",
    email: "jarlax1@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )

    meetup1 = Meetup.create(
    name: "launchers who lunch",
    description: "eating in chinatown",
    location: "chinatown",
    creator: user
    )

    visit '/'
    click_on "Create a New Meetup"
    fill_in "name", with: "Dumbledore's Army"
    fill_in "description", with: "underground defense against the dark arts"
    fill_in "location", with: "room of requirement"
    click_on "Submit"

    expect(page).to have_content("user must be signed in to make a new meetup")
    name_field = find_field('name')
    expect(name_field.value).to eq "Dumbledore's Army"
  end

  scenario "user signs in, submits form with empty location, raises empty form error, redirects to form with prefilled fields" do
    user = User.create(
    provider: "github",
    uid: "1",
    username: "jarlax1",
    email: "jarlax1@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )

    meetup1 = Meetup.create(
    name: "launchers who lunch",
    description: "eating in chinatown",
    location: "chinatown",
    creator: user
    )

    visit '/'
    sign_in_as user
    click_on "Create a New Meetup"

    fill_in "name", with: "Dumbledore's Army"
    fill_in "description", with: ""
    fill_in "location", with: "room of requirement"
    click_on "Submit"
    expect(page).to have_content("Description can't be blank")
    name_field = find_field('name')
    expect(name_field.value).to eq "Dumbledore's Army"
  end

  scenario "user does not sign in, submits form with empty location, raises multiple errors, redirects to form with prefilled fields" do
    user = User.create(
    provider: "github",
    uid: "1",
    username: "jarlax1",
    email: "jarlax1@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )

    meetup1 = Meetup.create(
    name: "launchers who lunch",
    description: "eating in chinatown",
    location: "chinatown",
    creator: user
    )

    visit '/'

    click_on "Create a New Meetup"

    fill_in "name", with: "Dumbledore's Army"
    fill_in "description", with: ""
    fill_in "location", with: "room of requirement"
    click_on "Submit"

    expect(page).to have_content("user must be signed in to make a new meetup")
    expect(page).to have_content("Description can't be blank")
    name_field = find_field('name')
    expect(name_field.value).to eq "Dumbledore's Army"
  end


  # test for alphabetical listing later
end
