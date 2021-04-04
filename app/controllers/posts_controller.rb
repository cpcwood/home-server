class PostsController < ApplicationController
  def index
    @posts = Post.order(date_published: :desc)
  end

  def show
    @post = Post.includes(:post_sections).find_by(id: sanitize(params[:id]))
    redirect_to(posts_path, alert: 'Post not found') unless @post
  end

  private

  def sanitize(string)
    ActiveRecord::Base.sanitize_sql(string) unless string.nil?
  end
end