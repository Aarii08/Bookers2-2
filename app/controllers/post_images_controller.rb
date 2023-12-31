class PostImagesController < ApplicationController

  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id
    if @post_image.save
      redirect_to post_images_path
    else
      render :new
    end
  end

  def index
    @post_images = PostImage.order(created_at: :desc).page(params[:page])
  end

  def show
    @post_image = PostImage.find(params[:id])
    @post_comment = PostComment.new
    unless ReadCount.find_by(user_id: current_user.id, post_image_id: @post_image.id)
      current_user.read_counts.create(post_image_id: @post_image.id)
    end
  end

  def edit
    @post_image = PostImage.find(params[:id])
  end

  def update
    post_image = PostImage.find(params[:id])
    post_image.update(post_image_params)
    redirect_to post_image_path(post_image)
  end

  def destroy
    post_image = PostImage.find(params[:id])
    post_image.destroy
    redirect_to post_images_path
  end

  private

  def post_image_params
    params.require(:post_image).permit(:name, :image, :caption)
  end

end
