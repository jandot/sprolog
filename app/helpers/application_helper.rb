# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def nice_date(date)
      h date.strftime("%A %d %B %Y - %H:%M %p")
  end
  def pdf_image_tag(image, options = {})
    options[:src] = File.expand_path(RAILS_ROOT) + '/public/images/' + image 
    tag(:img, options)
  end
end
