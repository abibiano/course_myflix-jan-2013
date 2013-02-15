class QueueItemsController < ApplicationController
  before_filter :require_user
  def index
    @queue_items = current_user.queue_items.all
  end

  def create
    video = Video.find(params[:video_id])
    @queue_item = current_user.queue_items.new(video: video)
    @queue_item.position = current_user.queue_items.count + 1
    if @queue_item.save
      redirect_to my_queue_path, notice: 'Video added to your queue'
    else
      @video = @queue_item.video
      render 'videos/show'
    end
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if queue_item.user == current_user
    flash[:success] = "Queue item deleted."
    redirect_to my_queue_path
  end

  def update_multiple
    unless params[:queue_items].nil?
      if QueueItem.save_multiple(params[:queue_items])
        current_user.reorder_queue_items
      end
    end
    redirect_to my_queue_path
  end

end