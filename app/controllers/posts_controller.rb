class PostsController < ApplicationController
  def index
    @posts = Post.order(date_published: :desc)
  end

  def show
    @post = Post.find_by(id: sanitize(params[:id]))
  end

  private

  def sanitize(string)
    ActiveRecord::Base.sanitize_sql(string) unless string.nil?
  end
end