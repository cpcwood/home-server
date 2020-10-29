module ApplicationHelper
  def header_height
    controllers = [/\Ahomepages\z/, /\Aadmins?/]
    return 300 if controllers.any? { |pattern| pattern.match?(params[:controller]) }
    205
  end
end