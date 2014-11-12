module HighlightHelper
  def highlight(hl, value)
    return value if hl.blank?
    return highlight_array(hl, value) if value.is_a?(Array)
    allow_highlight hl[0]
  end

  def highlight_array(hl, array)
    members = hl.map {|h| strip_tags(h)}
    result = array.map {|m|
      members.include?(m) ? allow_highlight(hl[members.index(m)]) : m
    }
    result
  end

  def allow_highlight(string)
    sanitize string, tags: %w{em}, attributes: %w{class}
  end
end
