module DateHelper
  def full_date(date)
    export_html(render_date(date))
  end

  def full_date_and_time(datetime)
    export_html("#{render_date(datetime)} at#{render_time(datetime)}")
  end

  def export_html(string)
    "<span>#{string}</span>".html_safe
  end

  def render_date(date)
    "#{date.strftime('%B %d')}<sup>#{date.day.ordinal}</sup>#{date.strftime(', %Y')}"
  end

  def render_time(datetime)
    datetime.strftime('%l:%M%p').downcase
  end
end
