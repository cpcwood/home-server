module DateHelper
  def full_date(date)
    "<span>#{date.strftime('%B %d')}<sup>#{date.day.ordinal}</sup>#{date.strftime(', %Y')}</span>".html_safe
  end
end
