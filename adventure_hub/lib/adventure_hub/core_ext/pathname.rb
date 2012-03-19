class Pathname
  def child_of?(other)
    return false if expand_path == other.expand_path

    !!(expand_path.cleanpath.to_s =~ Regexp.new("^#{other.expand_path.cleanpath.to_s}"))
  end

  def parent_of?(other)
    other.child_of?(self)
  end
end