module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def image_or_placeholder(photo, style = :square )
    if photo.exists?
      image_tag photo.url(style)
    else
      # TODO look up the correct dimensions when caller passes
      # in something other than :square
      geometry = photo.styles[style].geometry.chomp('#')
      image_tag "//placehold.it/#{geometry}"
    end
  end
end
