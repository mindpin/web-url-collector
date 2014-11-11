module HighlightHelper
  def highlight(hl, value)
    return value if hl.blank?
    return highlight_array(hl, value) if value.is_a?(Array)
    hl[0]
  end

  def highlight_array(hl, array)
    members = hl.map {|h| ActionView::Base.full_sanitizer.sanitize(h)}
    result = array.map {|m| members.include?(m) ? hl[members.index(m)] : m}
    result
  end
end
