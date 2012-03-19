class Pathname
  def child_of?(other)
    return false if cleanpath == other.cleanpath

    !!(cleanpath.to_s =~ Regexp.new("^#{other.cleanpath.to_s}"))
  end

  def parent_of?(other)
    other.child_of?(self)
  end
end