module AdventureHub
  module Models
    # a single file within a sequence
    class File

      attr_reader :sequence #parent of this file
      delegate :resource, :to => sequence

      attr_reader :path
      attr_reader :size
      attr_reader :index

    end
    
  end
end
