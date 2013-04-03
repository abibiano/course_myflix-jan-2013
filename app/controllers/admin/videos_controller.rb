class Admin::VideosController < AdminsController
  def new
    @video = Video.new
    @categories = Category.all
  end

  def create
    @video = Video.new(params[:video])
    if @video.save
      redirect_to home_path, notice: 'Video was succesfully created'
    else
      @categories = Category.all
      render :new
    end
  end
end