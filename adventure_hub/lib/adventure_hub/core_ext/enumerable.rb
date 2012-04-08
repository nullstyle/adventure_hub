
module Enumerable
  
  def summarize(&block)
    self.inject({}) do |result, item|
      value = block.nil? ? item : block.call(item)
      result[value] ||= 0
      result[value] += 1
      result
    end
  end

end