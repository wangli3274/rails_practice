class PostersController < ApplicationController
  before_action :set_poster, only: [:show, :edit, :update, :destroy]

  # GET /posters
  # GET /posters.json
  def index
    #@posters = Poster.all
    #@posters = Poster.all.page(params[:page]).per(5)
    @posters = Poster.all.page(params[:page])
    @posters.each do |poster|
      poster.tags = Tag.find(poster.tag_ids)
    end

    @title = "Poster"
    
  end

  # GET /posters/1
  # GET /posters/1.json
  def show
    @tags = Tag.find(@poster.tag_ids)
  end

  # GET /posters/new
  def new
    @poster = Poster.new
    @tags = Tag.all
  end

  # GET /posters/1/edit
  def edit
    @tags = Tag.all
    @p_tags = Tag.find(@poster.tag_ids)
  end

  # POST /posters
  # POST /posters.json
  def create
    @poster = Poster.new(poster_params)
  
    respond_to do |format|
      if @poster.save
        format.html { redirect_to @poster, notice: 'Poster was successfully created.' }
        format.json { render action: 'show', status: :created, location: @poster }
      else
        format.html { render action: 'new' }
        format.json { render json: @poster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posters/1
  # PATCH/PUT /posters/1.json
  def update
    respond_to do |format|
      if @poster.update(poster_params)
        format.html { redirect_to @poster, notice: 'Poster was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @poster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posters/1
  # DELETE /posters/1.json
  def destroy
    @poster.destroy
    respond_to do |format|
      format.html { redirect_to posters_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poster
      @poster = Poster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poster_params
      params.require(:poster).permit(:title, :content, :create_at, :update_at, :user_id, tag_ids:[])
      # params.require(:poster).permit(:title, :content, :create_at, :update_at, :user_id)
    end
end
