class QueueItemsController < ApplicationController
  before_filter :require_user
  def index
    @queue_items = current_user.queue_items.all
  end

  def create
    video = Video.find(params[:video_id])
    @queue_item = current_user.queue_items.new(video: video)     
    if @queue_item.save
      redirect_to my_queue_path, notice: 'Video added to your queue'
    else
      @video = @queue_item.video
      render 'videos/show'
    end
  end

  def destroy
    QueueItem.find(params[:id]).destroy
    flash[:success] = "Queue item deleted."
    redirect_to my_queue_path
  end
end