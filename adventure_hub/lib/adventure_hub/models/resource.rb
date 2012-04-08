module AdventureHub
  module Models

    class Resource
      include DataMapper::Resource

      property :id,           Serial
      property :imported,     Boolean, :default => false
      property :signature,    String
      property :type,         Enum[ :photo, :video, :journal, :gps, :audio, :unknown ]
      property :occurred_at,  DateTime
      property :duration,     Float
      property :metadata,     Json

      property :created_at,   DateTime
      property :updated_at,   DateTime

      has n,   :sequences, :constraint => :destroy

      def path
        Pathname.new("#{type}/#{id}")
      end
    end
    
  end
end
