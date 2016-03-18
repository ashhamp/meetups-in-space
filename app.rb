require 'sinatra'
require_relative 'config/application'
require 'pry'

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  current_user
  @meetups = Meetup.all.order(:name)
  # @success_message = session[:success_message]

  # binding.pry

  erb :'meetups/index'
end
get '/meetups/new' do
  @new_name = session[:name]
  @new_description = session[:description]
  @new_location = session[:location]
  session[:name] = nil
  session[:description] = nil
  session[:location] = nil


  erb :'meetups/new'
end

get '/meetups/:id' do

  @success = session[:success_message]
  session[:success_message] = nil

  @meetup = Meetup.find(params[:id])
  @attendees = @meetup.users
  @show_button = nil
  @member = @attendees.where(id: session[:user_id])
  @message = nil

  if @member.empty? || session[:user_id].nil?
    @show_button = true
  end

  erb :'meetups/show'
end

post '/meetups/:id' do
  unless session[:user_id].nil?
    MeetupsUser.create(user_id: session[:user_id], meetup_id: params[:id])
    flash[:notice] = "You've joined!"
  else
    flash[:notice] = "Please sign in to join group"
  end

  redirect "/meetups/#{params[:id]}"
end

post '/meetups' do
  @creator_id = session[:user_id]
  session[:name] = params[:name]
  session[:description] = params[:description]
  session[:location] = params[:location]

  @errors = ""
  if session[:user_id].nil?
    @errors += "user must be signed in to make a new meetup\n"
  end
  @meetup = Meetup.new(name: session[:name], description: session[:description], location: session[:location], creator_id: @creator_id)

  if @meetup.valid?
    @meetup.save
    flash[:notice] = "Event created!"
    redirect "/meetups/#{@meetup.id}"
  else
    @errors += @meetup.errors.full_messages.join(", ")
    flash[:notice] = "#{@errors}"
    redirect '/meetups/new'
  end
end
