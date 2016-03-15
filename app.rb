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
  @meetups = Meetup.all.order(:name)

  erb :'meetups/index'
end
get '/meetups/new' do
  @errors = []

  erb :'meetups/new'
end

get '/meetups/:id' do
  @meetup = Meetup.find(params[:id])
  @attendees = @meetup.users
  @show_button = nil
  @member = @attendees.where(id: session[:user_id])
  @message = nil

  if @member.empty? || session[:user_id].nil?
    @show_button = true
  end


  # if !session[:user_id].nil? && !@member.nil?
  #   @show_button = nil
  # end

  erb :'meetups/show'
end

post '/meetups/:id' do
  MeetupsUser.create(user_id: session[:user_id], meetup_id: params[:id])
  @message = "You've joined!"
  # erb :'/meetups/show'
  redirect "/meetups/#{params[:id]}"
end

post '/meetups' do
  # binding.pry
  # user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  @success = nil
  @creator_id = session[:user_id]
  @new_name = params[:name]
  @new_description = params[:description]
  @new_location = params[:location]
# binding.pry
  @errors = []
  if session[:user_id].nil?
    @errors << "user must be signed in to make a new meetup"
  end
  if @new_name.strip.empty? || @new_description.strip.empty? ||    @new_location.strip.empty?
    @errors << "user must fill all fields of form"
  end

  if !@errors.empty?
    erb :'meetups/new'
  else
    @success = "Event created!"
    @meetup = Meetup.create(name: @new_name, description: @new_description, location: @new_location, creator_id: @creator_id)
    redirect "/meetups/#{@meetup.id}"
    # add creator to user list?
  end

end
