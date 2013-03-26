get '/' do
  erb :index
end

get '/user' do
  redirect "/#{params[:username]}"
end

get '/:username' do
  puts params[:username]
  @user = Tweeter.find_by_username(params[:username])

  if @user.tweets.length == 0
    @user.fetch_tweets!
  end

  if @user.tweets_stale?
    @user.fetch_tweets!
  end
  
  @tweets = @user.tweets.limit(10)
  erb :profile
end
