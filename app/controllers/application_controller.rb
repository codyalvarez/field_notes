require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, "secret"
  end

  get "/" do
   "Welcome to Field Notes"
   erb :index
  end

  get '/signup' do
    if logged_in?
      redirect '/notes'
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do
    @user = User.new(username: params[:username], email: params[:email], password: params[:password])
    if @user.save
      session[:user_id] = @user.id 
      redirect '/notes'
    else
      redirect '/signup'
    end
  end

  get '/login' do
    if logged_in?
      redirect '/notes'
    else
      erb :'users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/notes'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/login'
    end
  end

  post '/logout' do
    if logged_in?
      redirect '/logout'
    else
      redirect '/login'
    end
  end

  helpers do

    def logged_in?
      !!current_user
    end
    
    def current_user
      User.find_by(id: session[:user_id])
    end

    def authenticate
      redirect '/login' if !logged_in?
    end

    def authorize(note)
      authenticate
      if note.user != current_user
        redirect '/notes'
      end
    end
  end


end
