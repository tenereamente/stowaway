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

  def image_or_placeholder(photo, size = :square )
    if photo.exists?
      image_tag photo.url(size)
    else
      # TODO look up the correct dimensions when caller passes
      # in something other than :square
      image_tag "http://placehold.it/200x200"
    end
  end
end
