module Admin
  class PostsController < AdminBaseController
    def index
      @posts = Post.order(date_published: :desc) || Post.new
      @posts = [Post.new] if @posts.empty?
    end

    def new
      @post = Post.new
    end
  end
end
