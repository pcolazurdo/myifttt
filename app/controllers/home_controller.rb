
class HomeController < ApplicationController
  def index
    tf = ApplicationHelper::TweeterFunctions.new()
    tf.favorites()
    
    @favtweets = Favtweet.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @favtweets }
    end
  end
end
