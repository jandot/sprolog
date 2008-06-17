# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def nice_date(date)
      h date.strftime("%A %d %B %Y - %H:%M %p")
  end
end
