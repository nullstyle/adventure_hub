module AdventureHub
  module Models
    # a single file within a sequence
    class File
      include DataMapper::Resource

      belongs_to :sequence, :key => true #parent of this file
      delegate :resource, :to => :sequence

      property :path,   FilePath, :key => true
      property :index,  Integer, :key => true
      
      property :size,   Integer

    end
    
  end
end
