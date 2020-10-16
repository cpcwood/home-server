module Admin
  class PostsController < AdminBaseController
    def index
      @posts = Post.order(date_published: :desc)
    end

    def new
      @post = Post.new
    end
  end
end
