class UserController < ApplicationController

  def mypage
    @user = current_user
    @post_images = @user.post_images.page(params[:page])
  end

  def index
    @users = User.all
    @my_user = User.find_by(id: current_user)
  end

  def show
    @user = User.find(params[:id])
    @post_images = @user.post_images.page(params[:page])
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id then
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      if @is_room
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    redirect_to user_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end

end
