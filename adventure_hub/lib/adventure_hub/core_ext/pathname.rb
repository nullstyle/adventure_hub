class Pathname
  def child_of?(other)
    return false if expand_path == other.expand_path

    !!(expand_path.cleanpath.to_s =~ Regexp.new("^#{other.expand_path.cleanpath.to_s}"))
  end

  def parent_of?(other)
    other.child_of?(self)
  end

  def has_child?(other)
    self.children.detect{|p| p.basename == other}
  end

  def has_child_dir?(other)
    self.children.detect{|p| p.directory? && p.basename == other}
  end

  def walk(&block)
    self.children.each do |child|
      child.directory? ? child.walk(&block) : block.call(child)
    end
  end
end