module AdminLinkHelper
  def admin_link_helper_admin_path(model, singular = false)
    if singular
      send(:"edit_admin_#{model.model_name.singular}_path")
    else
      send(:"edit_admin_#{model.model_name.singular}_path", model)
    end
  end

  def admin_link_helper_section_path(model, singular = false)
    if singular
      send(:"#{model.model_name.singular}_path")
    else
      send(:"#{model.model_name.plural}_path")
    end
  end

  def admin_link_helper_new_path(model)
    send(:"new_admin_#{model.model_name.singular}_path")
  end

  def in_admin_scope?
    current_path.match?(%r{^/admin/})
  end

  private

  def current_path
    request.original_fullpath
  end
end