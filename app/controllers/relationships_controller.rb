class RelationshipsController < AuthenticatedController
  def create
    @user = User.find(params[:user_id])
    current_user.follow!(@user)
    redirect_to user_path(@user)
  end

  def destroy
    @user = User.find(params[:id])
    current_user.unfollow!(@user)
    redirect_to people_path
  end
end