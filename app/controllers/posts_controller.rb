class PostsController < ApplicationController
  def index
    @posts = Post.order(date_published: :desc)
    @posts = [Post.new] if @posts.empty?
  end
end