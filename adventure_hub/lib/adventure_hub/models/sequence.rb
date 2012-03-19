module AdventureHub
  module Models
    # a sequence models a named collection of data files
    class Sequence
      include DataMapper::Resource

      belongs_to :resource, :key => true #parent of this sequence
      property :name, String, :key => true

      has n, :files

    end
    
  end
end
