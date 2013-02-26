class AudioClipsController < ApplicationController



  # GET /audio_clips
  # GET /audio_clips.json
  def index
    @audio_clips = AudioClip.limit(params[:limit]).offset(params[:offset]).order("created_at DESC").all
   
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @audio_clips}#.order("created_at DESC")}
    end
  end

  # GET /audio_clips/1
  # GET /audio_clips/1.json
  def show
    @audio_clip = AudioClip.find(params[:id])
    
   #    @client = Foursquare2::Client.new(:client_id => 'MLGORRLYKVWVSEMAKWHQURQVIEAZEJ5PSESSRER3VK4XBHRL', :client_secret => 'JT11S30HAAOSMQYEA2CU3QQXB1DEPK5ESQTIM0CUFM1UB2NB')
   # @audio_clip.fsvenue = @client.search_venues(:ll => '36.142064,-86.816086')
     unless @audio_clip.latitude.blank? || @audio_clip.longitude.blank?
      @fsquare_response = open("https://api.foursquare.com/v2/venues/search?ll=#{@audio_clip.latitude},#{@audio_clip.longitude}&llAcc=100&limit=1&oauth_token=FNUK2E0Z5BI33J0BRQBR3FZWBBYEUSY4LAX1WE1NPAQDDIHT&v=20130203").read
       @result = ActiveSupport::JSON.decode(@fsquare_response)
       @venue = @result["response"]["venues"][0]["name"]
       end

    respond_to do |format|
      format.html # show.html.erb
        format.json { render :json => @audio_clip }
   
      # format.json  { render :json => @audio_clip.to_json(:include => [:facebook_id])}
    end
  end

  # GET /audio_clips/new
  # GET /audio_clips/new.json
  def new
    @audio_clip = AudioClip.new
   

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @audio_clip }
    end
  end

  # GET /audio_clips/1/edit
  def edit
    @audio_clip = AudioClip.find(params[:id])
  end

  # POST /audio_clips
  # POST /audio_clips.json
  def create
    @audio_clip = AudioClip.new(params[:audio_clip])
   @audio_clip.sound_file = params[:sound_file]
   @audio_clip.user_id = params[:user_id]
   # @client = Foursquare2::Client.new(:client_id => 'MLGORRLYKVWVSEMAKWHQURQVIEAZEJ5PSESSRER3VK4XBHRL', :client_secret => 'JT11S30HAAOSMQYEA2CU3QQXB1DEPK5ESQTIM0CUFM1UB2NB')
   # @audio_clip.fsvenue = @client.search_venues(:ll => '36.142064,-86.816086')
       unless @audio_clip.latitude.blank? || @audio_clip.longitude.blank?
      @fsquare_response = open("https://api.foursquare.com/v2/venues/search?ll=#{@audio_clip.latitude},#{@audio_clip.longitude}&llAcc=100&limit=1&oauth_token=FNUK2E0Z5BI33J0BRQBR3FZWBBYEUSY4LAX1WE1NPAQDDIHT&v=20130203").read
       @result = ActiveSupport::JSON.decode(@fsquare_response)
       @audio_clip.fsvenue = @result["response"]["venues"][0]["name"]
       end

      #  if @audio_clip.user_id.blank?
      #   @audio_clip.user_id == User.audio_clip.id
      # end


    respond_to do |format|
      if @audio_clip.save
        format.html { redirect_to @audio_clip, notice: 'Audio clip was successfully created.' }
        format.json { render json: @audio_clip, status: :created, location: @audio_clip }
      else
        format.html { render action: "new" }
        format.json { render json: @audio_clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /audio_clips/1
  # PUT /audio_clips/1.json
  def update
    @audio_clip = AudioClip.find(params[:id])

    respond_to do |format|
      if @audio_clip.update_attributes(params[:audio_clip])
        format.html { redirect_to @audio_clip, notice: 'Audio clip was successfully updated.' }
        format.json { render :json => @audio_clip }
      else
        format.html { render action: "edit" }
        format.json { render json: @audio_clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audio_clips/1
  # DELETE /audio_clips/1.json
  def destroy
    @audio_clip = AudioClip.find(params[:id])
    @audio_clip.destroy

    respond_to do |format|
      format.html { redirect_to audio_clips_url }
      format.json { head :no_content }
    end
  end
end
