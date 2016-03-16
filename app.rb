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
  @errors = []

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
    session[:success_message] = "You've joined!"
  else
    session[:success_message] = "Please sign in to join group"
  end

  redirect "/meetups/#{params[:id]}"
end

post '/meetups' do
  @success = nil
  @creator_id = session[:user_id]
  @new_name = params[:name]
  @new_description = params[:description]
  @new_location = params[:location]

  @errors = ""
  if session[:user_id].nil?
    @errors += "user must be signed in to make a new meetup\n"
  end
  @meetup = Meetup.new(name: @new_name, description: @new_description, location: @new_location, creator_id: @creator_id)

  if @meetup.valid?
    @meetup.save
  else
    @meetup.errors.messages.each do |column, msg|
      @errors += "#{column.to_s}: "
      msg.each_with_index do |s, index|
        @errors += "#{s}"
        if (index + 1) < msg.size
          @errors += ","
        end
      end
      @errors += "\n"
    end
  end


  if !@errors.empty?
    erb :'meetups/new'
  else
    session[:success_message] = "Event created!"
    redirect "/meetups/#{@meetup.id}"
  end

end
