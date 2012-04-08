module AdventureHub
  module Models
    # a single file within a sequence
    class File
      include DataMapper::Resource

      belongs_to :sequence, :key => true #parent of this file
      property :position, Integer,  :key => true, :default => 0, :unique => false

      delegate :resource, :to => :sequence
      belongs_to :disk, :required => false

      is :list, :scope => :sequence
      
      property :extname,  String
      property :size,   Integer

      after :destroy, :remove_path

      def path
        Pathname.new(disk.resources_path(true) + sequence.path + "#{position}#{extname}")
      end

      private
      def remove_path
        path.delete if path.exist?
        path.clear_empty_parents
      end
    end
    
  end
end
