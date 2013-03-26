class Tweeter < ActiveRecord::Base
  has_many :tweets

  def self.find_by_username(username)
    Tweeter.find_or_create_by_username(Twitter.user(username).username)
  end

  def fetch_tweets!
    tweets = Twitter.user_timeline(self.username)
    tweets.each do |tweet|
      self.tweets.find_or_create_by_tweeted_at(tweet.created_at,
                                              :text => tweet.text,
                                              :tweeted_at => tweet.created_at) 
    end
  end
  
  def tweets_stale?
    tweets = self.tweets
    tweets_total = tweets.length
    first_tweet = tweets.shift
    average = 0

    sum = tweets.inject(0) do |s, tweet|
      time = first_tweet.tweeted_at - tweet.tweeted_at  
      first_tweet = tweet
      time + s
    end

    average = sum / tweets_total
    puts (((average/60)/60)/24)
    ((Time.now - self.tweets.last.created_at) > (average/2)) || ((Time.now - self.tweets.last.created_at) > 3600)
  end

end
