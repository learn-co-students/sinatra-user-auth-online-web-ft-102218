class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  get '/registrations/signup' do
    erb :'/registrations/signup'
  end

  post '/registrations' do
    @user = User.create(params)
    @user.save
    session[:id] = @user.id
    redirect '/users/home'
  end

  get '/sessions/login' do
    if session[:message]
      @message = session[:message]
    end
    erb :'sessions/login'
  end

  post '/sessions' do
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user != nil
      session[:id] = @user.id
      redirect '/users/home'
    else
      session[:message] = "Incorrect User Name or Password"
      redirect '/sessions/login'
    end
  end

  get '/sessions/logout' do 
    session.clear
    redirect '/'
  end

  get '/users/home' do
    @user = User.find_by_id(session[:id])
    erb :'/users/home'
  end

end
