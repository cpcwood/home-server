module Admin
  class PostsController < AdminBaseController
    def index
      @posts = Post.order(date_published: :desc) || Post.new
      @posts = [Post.new] if @posts.empty?
    end

    def new
      @post = Post.new
    end

    def create
      @user.posts.create(permitted_params)
      redirect_to(admin_posts_path, notice: 'New blog post created')        
    end

    private

    def permitted_params
      params.require(:post).permit([
        :title,
        :overview,
        :date_published,
        :text
      ])
    end
  end
end
