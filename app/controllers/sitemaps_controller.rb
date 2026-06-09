# Serves the sitemap from the database on each request, so it's always current
# and identical across replicas — a file in a pod's public/ would go stale
# between deploys and drift per replica. Skips the inherited user/site-settings
# loading and ahoy tracking: a crawler isn't a user.
class SitemapsController < ApplicationController
  skip_before_action :assign_user, :assign_site_setings
  skip_after_action :track_action

  def show
    @posts = Post.all
    @code_snippets = CodeSnippet.all
    expires_in 1.hour, public: true
  end
end
