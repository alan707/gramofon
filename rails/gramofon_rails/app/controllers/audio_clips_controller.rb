class AudioClipsController < ApplicationController
  # GET /audio_clips
  # GET /audio_clips.json
  def index
    @audio_clips = AudioClip.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @audio_clips }
    end
  end

  # GET /audio_clips/1
  # GET /audio_clips/1.json
  def show
    @audio_clip = AudioClip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @audio_clip }
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
        format.json { head :no_content }
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
