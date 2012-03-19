class Pathname
  def underneath?(other)
    return false if cleanpath == other.cleanpath

    !!(cleanpath.to_s =~ Regexp.new("^#{other.cleanpath.to_s}"))
  end
end