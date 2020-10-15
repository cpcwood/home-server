module AdminLinkHelper
  def admin_link_helper_edit_link
    current_path = request.original_fullpath
    "/admin#{current_path}/edit"
  end

  def in_admin_scope?
    current_path = request.original_fullpath
    current_path.match?(/^\/admin\//)
  end
end