module ApplicationHelper
  def icon(icon_class)
    content_tag 'span', '', class: icon_class.to_s
  end

  def boolean_label(value)
    case value
    when true
      content_tag 'span', value, class: 'badge badge-success'
    when false
      content_tag 'span', value, class: 'badge badge-danger'
    end
  end
end
