module ApplicationHelper
  def icon(icon_class)
    content_tag 'span', '', class: icon_class.to_s
  end
end
