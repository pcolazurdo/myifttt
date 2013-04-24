# Load libraries required by the Evernote OAuth sample applications
require 'oauth'
require 'oauth/consumer'

# Load Thrift & Evernote Ruby libraries
require "evernote_oauth"
module E
  class Evernote
# Client credentials
# Fill these in with the consumer key and consumer secret that you obtained
# from Evernote. If you do not have an Evernote API key, you may request one
# from http://dev.evernote.com/documentation/cloud/

    def initialize(*)
      @ercfile = ERCFile.instance
      super
    end

    OAUTH_CONSUMER_KEY = ERCFile.active_consumer_key
    #OAUTH_CONSUMER_KEY = ERCFile.active_consumer_key

    SANDBOX = true
  end
end