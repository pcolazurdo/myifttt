class FavtweetsController < ApplicationController
  # GET /favtweets
  # GET /favtweets.json
  def index
    @favtweets = Favtweet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @favtweets }
    end
  end

  # GET /favtweets/1
  # GET /favtweets/1.json
  def show
    @favtweet = Favtweet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @favtweet }
    end
  end

  # GET /favtweets/new
  # GET /favtweets/new.json
  def new
    @favtweet = Favtweet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @favtweet }
    end
  end

  # GET /favtweets/1/edit
  def edit
    @favtweet = Favtweet.find(params[:id])
  end

  # POST /favtweets
  # POST /favtweets.json
  def create
    @favtweet = Favtweet.new(params[:favtweet])

    respond_to do |format|
      if @favtweet.save
        format.html { redirect_to @favtweet, notice: 'Favtweet was successfully created.' }
        format.json { render json: @favtweet, status: :created, location: @favtweet }
      else
        format.html { render action: "new" }
        format.json { render json: @favtweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /favtweets/1
  # PUT /favtweets/1.json
  def update
    @favtweet = Favtweet.find(params[:id])

    respond_to do |format|
      if @favtweet.update_attributes(params[:favtweet])
        format.html { redirect_to @favtweet, notice: 'Favtweet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @favtweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favtweets/1
  # DELETE /favtweets/1.json
  def destroy
    @favtweet = Favtweet.find(params[:id])
    @favtweet.destroy

    respond_to do |format|
      format.html { redirect_to favtweets_url }
      format.json { head :no_content }
    end
  end
end
