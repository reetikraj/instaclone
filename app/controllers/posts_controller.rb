class PostsController < ApplicationController
	
	before_action :authenticate_user!
	before_action :set_post, only: [:show, :edit, :update, :destroy]
	before_action :owned_post, only: [:edit, :update, :destroy]

	def index
		#@posts = Post.order(created_at: :desc).page(params[:page]).per(2)
        @posts = Post.paginate(page: params[:page], per_page: 2).order('created_at DESC')
    #@posts = Post.all
    respond_to do |format|
     format.html
     format.js
   end
    end

	def new
    @post = current_user.posts.build
    end

    def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = "Your post has been created!"
      redirect_to posts_path
    else
      flash[:alert] = "Your new post couldn't be created!  Please check the form."
      render :new
    end
    end
    
    def wall 
    @posts = Post.paginate(page: params[:page], per_page: 2).order('created_at DESC')
    #@posts = Post.all
    respond_to do |format|
     format.html
     format.js
   end
    end

    def show
        
    end

    def update
    if @post.update(post_params)
      flash[:success] = "Post updated."
      redirect_to posts_path
    else
      flash.now[:alert] = "Update failed.  Please check the form."
      render :edit
    end
    end 

    def edit
        
   	end

	def destroy
  		
  		@post.destroy
  		flash[:success] = "Your post has been deleted successfully."
  		redirect_to posts_path
	end

    private
    
    def set_post
    	@post = Post.find_by_id(params[:id])
  	end

    def post_params
        params.require(:post).permit(:image, :caption)
    end

    def owned_post
  	unless current_user == @post.user
    flash[:alert] = "That post doesn't belong to you!"
    redirect_to root_path
  	end
	end
end
