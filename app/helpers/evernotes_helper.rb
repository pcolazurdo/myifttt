require 'digest/md5'
require 'evernote-thrift'
require 'time'
require 'ercfile'

module EvernotesHelper
  class Evernotes
    def initialize
      
    end
    
    def createNotesFromPendingTweets
      allfavtweets = Favtweet.all
      ev = EvernoteNote.new
      count = 0
      allfavtweets.each do |tw|
        if tw.timestamp == nil then          
          ev.save(tw) 
          tw.timestamp = Time.now.utc
          tw.save
          count = count + 1
        end
      end
      @newNotes = count        
    end
  end
  
  class EvernoteNote
    
    def initialize ()
      @authToken = E::ERCFile.active_consumer_key
      evernoteHost = "sandbox.evernote.com"
      userStoreUrl = "https://#{evernoteHost}/edam/user"

      @userStoreTransport = Thrift::HTTPClientTransport.new(userStoreUrl)
      @userStoreProtocol = Thrift::BinaryProtocol.new(@userStoreTransport)
      @userStore = Evernote::EDAM::UserStore::UserStore::Client.new(@userStoreProtocol)

      versionOK = @userStore.checkVersion("Evernote EDAMTest (Ruby)",
      Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
      Evernote::EDAM::UserStore::EDAM_VERSION_MINOR)
      puts "Is my Evernote API version up to date?  #{versionOK}"
      puts
      exit(1) unless versionOK
      
    end
    
    def save(twit)
      noteStoreUrl = @userStore.getNoteStoreUrl(@authToken)

      noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
      noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
      noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)

      # List all of the notebooks in the user's account
      notebooks = noteStore.listNotebooks(@authToken)
      puts "Found #{notebooks.size} notebooks:"
      defaultNotebook = notebooks.first
      notebooks.each do |notebook|
        puts "  * #{notebook.name}"
      end

      puts
      puts "Creating a new note in the default notebook: #{defaultNotebook.name}"
      puts

      # To create a new note, simply create a new Note object and fill in
      # attributes such as the note's title.
      note = Evernote::EDAM::Type::Note.new
      note.title = "Tweet from #{twit.screen_name}"
      note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>#{twit.full_text}<br/>
</en-note>
EOF

# Finally, send the new note to Evernote using the createNote method
# The new Note object that is returned will contain server-generated
# attributes such as the new note's unique GUID.
      createdNote = noteStore.createNote(@authToken, note)

      puts "Successfully created a new note with GUID: #{createdNote.guid}"
    end
  end
end
