module Admin
  class PostsController < AdminBaseController
    def new
      @post = Post.new
      render layout: 'layouts/admin_dashboard'
    end

    def create
      @notices = []
      @alerts = []
      begin
        @post = @user.posts.new
        update_post(post: @post, success_message: 'Blog post created')
        update_post_sections(post: @post)
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
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
        redirect_to(post_path(@post), notice: @notices)
      end
    end

    def edit
      @post = find_post
      return redirect_to(posts_path, alert: 'Post not found') unless @post
      render layout: 'layouts/admin_dashboard'
    end

    def update
      @notices = []
      @alerts = []
      begin
        @post = find_post
        return redirect_to(posts_path, alert: 'Post not found') unless @post
        update_post(post: @post, success_message: 'Blog post updated')
        update_post_sections(post: @post)
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
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
        redirect_to(post_path(@post), notice: @notices)
      end
    end

    def destroy
      @notices = []
      @alerts = []
      begin
        @post = find_post
        return redirect_to(posts_path, alert: 'Post not found') unless @post
        @post.destroy
        @notices.push('Blog post removed')
      rescue StandardError => e
        logger.error("RESCUE: #{caller_locations.first}\nERROR: #{e}\nTRACE: #{e.backtrace.first}")
        @alerts.push('Sorry, something went wrong!')
        @alerts.push(e.message)
      end
      redirect_to(posts_path, notice: @notices, alert: @alerts)
    end

    private

    def post_params
      params
        .require(:post)
        .permit(
          :title,
          :overview,
          :date_published)
    end

    def post_section_params
      permitted_params = params
        .require(:post)
        .permit(
          post_sections_attributes: [
            :id, 
            :_destroy, 
            :text, 
            :order,
            post_section_image_attributes: [
              :id,
              :_destroy,
              :image_file,
              :title
            ]
          ]
        )
      permitted_params[:post_sections_attributes].each do |key, post_section| \
        if post_section[:post_section_image_attributes].values.all?(&:blank?)
          post_section.delete(:post_section_image_attributes)
        end
      end
      permitted_params
    end

    def find_post
      Post.includes(:post_sections).find_by(id: params[:id])
    end

    def update_post(post:, success_message:)
      if post.update(post_params)
        @notices.push(success_message)
      else
        @alerts.push(post.errors.messages.to_a.flatten.last)
      end
    end

    def update_post_sections(post:)
      post.update(post_section_params)
    end
  end
end
