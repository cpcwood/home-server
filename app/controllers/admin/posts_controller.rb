module Admin
  class PostsController < AdminBaseController
    def index
      @posts = Post.order(date_published: :desc)
    end

    def new
      @post = Post.new
    end

    def create
      @notices = []
      @alerts = []
      begin
        @post = @user.posts.new
        update_post(post: @post, success_message: 'Blog post created')
      rescue StandardError => e
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      if @alerts.any?
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
      @post = find_post
    end

    def update
      @notices = []
      @alerts = []
      begin
        @post = find_post
        return redirect_to(admin_posts_path, alert: 'Post not found') unless @post
        update_post(post: @post, success_message: 'Blog post updated')
      rescue StandardError => e
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      if @alerts.any?
        flash[:alert] = @alerts
        render(
          partial: 'partials/form_replacement',
          locals: {
            selector_id: 'admin-post-edit-form',
            form_partial: 'admin/posts/edit_form',
            model: { post: @post }
          },
          formats: [:js])
        flash[:alert] = nil
      else
        redirect_to(admin_posts_path, notice: @notices)
      end
    end

    def destroy
      @notices = []
      @alerts = []
      begin
        @post = find_post
        return redirect_to(admin_posts_path, alert: 'Post not found') unless @post
        @post.destroy
        @notices.push('Blog post removed')
      rescue StandardError => e
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      redirect_to(admin_posts_path, notice: @notices, alert: @alerts)
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

    def find_post
      Post.find_by(id: params[:id])
    end

    def update_post(post:, success_message:)
      if post.update(permitted_params)
        @notices.push(success_message)
      else
        @alerts.push(post.errors.values.flatten.last)
      end
    end
  end
end
