require 'pathname'

class Object
  def actor?
    false
  end

  def path(str)
    Pathname.new(str)
  end
end