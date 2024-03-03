module ApplicationHelper
  def reset_tag(value = "Reset form", options = {})
    options = options.stringify_keys
    tag :input, { type: "reset", value: value }.update(options)
  end
end
