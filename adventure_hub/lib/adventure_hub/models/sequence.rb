module AdventureHub
  module Models
    # a sequence models a named collection of data files
    class Sequence
      include DataMapper::Resource

      belongs_to :resource, :key => true #parent of this sequence
      property :name, String, :key => true, :unique => false
      property :source, Boolean
      has n, :files


      def path
        resource.path + self.name
      end
    end
    
  end
end
