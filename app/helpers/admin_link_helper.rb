module AdminLinkHelper
  def admin_link_helper_admin_path(model)
    if model.is_a?(Enumerable)
      send("admin_#{model.first.model_name.plural}_path")
    else
      send("edit_admin_#{model.model_name.singular}_path")
    end
  end

  def admin_link_helper_section_path(model)
    if model.is_a?(Enumerable)
      send("#{model.first.model_name.plural}_path")
    else
      send("#{model.model_name.singular}_path")
    end
  end

  def admin_link_helper_new_path(model)
    send("new_admin_#{model.model_name.singular}_path")
  end

  def in_admin_scope?
    current_path.match?(%r{^/admin/})
  end

  private

  def current_path
    request.original_fullpath
  end
end