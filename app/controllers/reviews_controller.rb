class ReviewsController < AuthenticatedController
  def create
    @review = Review.new(params[:review])
    @review.video = Video.find(params[:video_id])
    @review.user = current_user
    if @review.save
      redirect_to video_path(@review.video), notice: 'Review was succesfully saved'
    else
      @video = @review.video
      render 'videos/show'
    end
  end
end