require 'forwardable'
require 'oauth'
require 'twitter'
require 't'
require 'digest/md5'
require 'htmlentities'

module ApplicationHelper
  class TweeterFunctions
    extend Forwardable
    include T::Collectable
    include T::Printable
    include T::Requestable
    include T::Utils

    DEFAULT_NUM_RESULTS = 200
    # DIRECT_MESSAGE_HEADINGS = ["ID", "Posted at", "Screen name", "Text"]
    # TREND_HEADINGS = ["WOEID", "Parent ID", "Type", "Name", "Country"]
    
    def initialize(*)
      @rcfile = T::RCFile.instance
      super
    end
    
    def options
      @options = {}
      return @options
    end
    
    def favorites(user=nil)
      if user      
        user = user.strip_ats
      end
      count = DEFAULT_NUM_RESULTS
      tweets = collect_with_count(count) do |count_opts|
        client.favorites(user, count_opts)     
      end 
      save_tweets(tweets)
    end
    
    def save_tweets(sometweets)
      sometweets.each do |tweet|
        save_message(tweet.user.screen_name, decode_urls(tweet.full_text, options['decode_urls'] ? tweet.urls : nil))  
      end
    end
    
    def save_message(from_user, message)
      full_text = HTMLEntities.new.decode(message)
      md5hash = Digest::MD5.hexdigest(from_user + full_text)
      @ft = Favtweet.find(:all, :conditions => [ "contenthash LIKE ?", "%" + md5hash + "%" ] )
      if @ft.count > 0 then return end # If not found then we can safely add it into the database
      @favtweet = Favtweet.new      
      @favtweet.screen_name = from_user      
      @favtweet.full_text = full_text
      @favtweet.contenthash = md5hash
      #Here we should add to the evernote note       
      @favtweet.save      
    end
  end
end


