require 'time'

module EvernotesHelper
  class Evernotes
    def initialize
      
    end
    
    def createNotesFromPendingTweets
      allfavtweets = Favtweet.all
      count = 0
      allfavtweets.each do |tw|
        if tw.timestamp == nil then          
          EvernoteNote.new(tw) 
          #tw.timestamp = Time.now.utc
          tw.save
          count ++
        end
      end
      @newNotes = count        
    end
  end
  
  class EvenoteNote
    def initialize (tw)
      
    end
end
