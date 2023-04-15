module ApplicationHelper
  def svg_icon(name)
    content_tag :use, nil, "xlink:href": asset_path("icons.svg##{name}")
  end

  def svg_title(title)
    content_tag :title, title
  end

  def icon(name, title = "", classes = nil, options = {})
    content_tag(:svg, svg_title(title) + svg_icon(name), class: classes.to_s, **options)
  end

  def page_title_classes
    "text-center text-3xl font-bold text-navy"
  end
end
