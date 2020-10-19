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
      @notices = []
      @alerts = []
      begin
        create_post
      rescue StandardError => e
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      if @alerts.any?
        @post = Post.new(permitted_params)
        flash[:alert] = @alerts
        render(
          partial: 'partials/form_replacement',
          locals: {
            selector_id: 'admin-post-new-form',
            form_partial: 'admin/posts/new_form',
            model: { post: @post }
          },
          formats: [:js])
        flash[:alert] = nil
      else
        redirect_to(admin_posts_path, notice: @notices)
      end
    end

    def edit
      assign_post
    end

    def update
      assign_post
      @post.update(permitted_params)
      redirect_to(admin_posts_path, notice: 'Blog post updated')
    end

    private

    def permitted_params
      params
        .require(:post)
        .permit(
          :title,
          :overview,
          :date_published,
          :text)
    end

    def create_post
      new_post = @user.posts.new
      if new_post.update(permitted_params)
        @notices.push('New blog post created')
      else
        @alerts.push(new_post.errors.values.flatten.last)
      end
    end

    def assign_post
      @post = Post.find(params[:id])
    end
  end
end
