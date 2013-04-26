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
      ercfile = E::ERCFile.instance
      @authToken = ercfile.active_consumer_key
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
      noteStoreUrl = @userStore.getNoteStoreUrl(@authToken)

      noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
      noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
      @noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)

      # List all of the notebooks in the user's account
      notebooks = @noteStore.listNotebooks(@authToken)
      puts "Found #{notebooks.size} notebooks:"
      defaultNotebook = notebooks.first
      notebooks.each do |notebook|
        puts "  * #{notebook.name}"
      end
      puts
      puts "Notes will be created in the default notebook: #{defaultNotebook.name}"
      puts
    end
    
    def translate_error(e)
      error_name = "unknown"
      case e.errorCode
      when Evernote::EDAM::Error::EDAMErrorCode::AUTH_EXPIRED
        error_name = "AUTH_EXPIRED"
      when Evernote::EDAM::Error::EDAMErrorCode::BAD_DATA_FORMAT
        error_name = "BAD_DATA_FORMAT"
      when Evernote::EDAM::Error::EDAMErrorCode::DATA_CONFLICT
        error_name = "DATA_CONFLICT"
      when Evernote::EDAM::Error::EDAMErrorCode::DATA_REQUIRED
        error_name = "DATA_REQUIRED"
      when Evernote::EDAM::Error::EDAMErrorCode::ENML_VALIDATION
        error_name = "ENML_VALIDATION"
      when Evernote::EDAM::Error::EDAMErrorCode::INTERNAL_ERROR
        error_name = "INTERNAL_ERROR"
      when Evernote::EDAM::Error::EDAMErrorCode::INVALID_AUTH
        error_name = "INVALID_AUTH"
      when Evernote::EDAM::Error::EDAMErrorCode::LIMIT_REACHED
        error_name = "LIMIT_REACHED"
      when Evernote::EDAM::Error::EDAMErrorCode::PERMISSION_DENIED
        error_name = "PERMISSION_DENIED"
      when Evernote::EDAM::Error::EDAMErrorCode::QUOTA_REACHED
        error_name = "QUOTA_REACHED"
      when Evernote::EDAM::Error::EDAMErrorCode::SHARD_UNAVAILABLE
        error_name = "SHARD_UNAVAILABLE"
      when Evernote::EDAM::Error::EDAMErrorCode::UNKNOWN
        error_name = "UNKNOWN"
      when Evernote::EDAM::Error::EDAMErrorCode::VALID_VALUES
        error_name = "VALID_VALUES"
      when Evernote::EDAM::Error::EDAMErrorCode::VALUE_MAP
        error_name = "VALUE_MAP"
      end
      rv = "Error code was: #{error_name}[#{e.errorCode}] and parameter: [#{e.parameter}]"
    end
    
    def save(twit)
      # To create a new note, simply create a new Note object and fill in
      # attributes such as the note's title.
      note = Evernote::EDAM::Type::Note.new
      
      puts "Saving Note from #{twit.screen_name}"
      puts "note: #{twit.full_text}"
      
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
      begin
        createdNote = @noteStore.createNote(@authToken, note)
      rescue Evernote::EDAM::Error::EDAMUserException => e
       #the exceptions that come back from Evernote are hard to read, but really important to keep track of
        msg = "Caught an exception from Evernote trying to create a note.  #{translate_error(e)}"
        raise msg
      end
      

      puts "Successfully created a new note with GUID: #{createdNote.guid}"
    end
  end
end
