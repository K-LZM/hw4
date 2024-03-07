class EntriesController < ApplicationController

  def index
    if User.find_by({"id" => session["user_id"]}) != nil
      @entries = Entry.all
      @entry = Entry.find_by({ "id" => params["id"] })
      @place = Place.find_by({ "id" => @entries["place_id"] })

      # respond_to do |format|
      #   format.html #{ render :template => "posts/index" }
      #   format.json { render :json => @entries }
    else
      flash["notice"] = "Login first please."
      redirect_to "/login"
    end
  end

  def new
    @place = Place.find_by({ "id" => params["place_id"] })
    @user = User.find_by({ "id" => session["user_id"] })
  end

  def create
    @user = User.find_by({ "id" => session["user_id"] })
    if @user != nil
      @entry = Entry.new
      @entry["title"] = params["title"]
      @entry["description"] = params["description"]
      @entry["occurred_on"] = params["occurred_on"]
      @entry["place_id"] = params["place_id"]
      @entry["image"] = params["image"]
      @entry.uploaded_image.attach(params["uploaded_image"])
      @entry["user_id"] = @user["id"]
      @entry.save
    else
      flash["notice"] = "Login first."
    end
    redirect_to "/places/#{@entry["place_id"]}"
  end

  def edit
    @entry = Entry.find_by({ "id" => params["id"] })
    @place = Place.find_by({ "id" => @entry["place_id"] })
  end

  def destroy
    @entry = Entry.find_by({ "id" => params["id"] })
    @entry.destroy
    redirect_to "/places/#{@entry["place_id"]}"
  end
  
  before_action :allow_cors
  def allow_cors
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email, X-User-Token, X-User-Email'
    response.headers['Access-Control-Max-Age'] = '1728000'
  end
end
