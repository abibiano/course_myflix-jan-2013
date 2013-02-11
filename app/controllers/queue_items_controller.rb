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
    QueueItem.find(params[:id]).destroy
    flash[:success] = "Queue item deleted."
    redirect_to my_queue_path
  end

  def update_multiple
    if !params[:queue_items].nil?
      params[:queue_items].each do |queue_item_hash|
        queue_item = QueueItem.find(queue_item_hash[0])
        queue_item.update_attributes(queue_item_hash[1])
      end
      current_user.queue_items.all.each_with_index do |queue_item, index|
        queue_item.position = index + 1
        queue_item.save
      end  
    end    
    redirect_to my_queue_path
  end
end