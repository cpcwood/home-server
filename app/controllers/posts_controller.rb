class PostsController < ApplicationController
  def index
    @posts = Post.order(date_published: :desc)
  end
end