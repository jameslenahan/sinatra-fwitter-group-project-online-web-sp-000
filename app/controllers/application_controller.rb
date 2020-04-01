require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if logged_in?
      redirect '/tweets/tweets'
    else
    erb :'/users/create_user'
    end
  end

  post '/signup' do

    if params[:username] == '' || params[:email] =='' || params[:password] == ''
      redirect '/signup'
    else
      user = User.create(params)
      session[:user_id] = user.id
      redirect '/tweets/tweets'
    end
  end

  def logged_in?
    !!current_user
  end

  def login(username, password)
    user = User.find_by(:username => username)
    if  user && user.authenticate(password)
  	session[:id] = user.id
    else
  	 redirect "/login"
    end
  end

  def current_user
    @current_user ||= User.find_by(:user_id => session[:user_id]) if session[:user_id]

  end

  def login_sequence
    if !logged_in?
      redirect '/login'
    end

  end

  def log_out
    session.destroy
  end
end