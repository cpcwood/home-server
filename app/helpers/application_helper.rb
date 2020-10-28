module ApplicationHelper
  def header_height
    controllers = [/\Ahomepages\z/, /\Aadmins?/]
    return '300px' if controllers.any? { |pattern| pattern.match?(params[:controller]) }
    '205px'
  end
end