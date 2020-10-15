module AdminLinkHelper
  def admin_link_helper_edit_link
    "/admin#{current_path}/edit"
  end

  def in_admin_scope?
    current_path.match?(%r{^/admin/})
  end

  def admin_link_helper_return_link
    current_path[%r{^/admin((/[\w\-.~/]+)(?=/edit$)|(/[\w\-.~/]+$))}, 1]
  end

  private

  def current_path
    request.original_fullpath
  end
end