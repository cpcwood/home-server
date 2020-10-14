module AdminLinkHelper
  def admin_link_helper_edit_link
    current_path = request.original_fullpath
    current_path.sub(%r{/([\w\-.~]+)$}, '/admin/\1/edit')
  end
end