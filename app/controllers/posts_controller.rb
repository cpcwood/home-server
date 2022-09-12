class PostsController < ApplicationController
  def index
    @posts = if @user
               Post.all.order(date_published: :desc)
             else
               Post.where(visible: true).order(date_published: :desc)
             end
  end

  def show
    @post = Post.includes(post_sections: [:post_section_image]).find_by(id: sanitize(params[:id]))
    redirect_to(posts_path, alert: 'Post not found') unless @post
  end

  private

  def sanitize(string)
    ActiveRecord::Base.sanitize_sql(string) unless string.nil?
  end
end
