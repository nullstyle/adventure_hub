module AdventureHub
  module Models

    class Resource
      include DataMapper::Resource

      property :id,           Serial
      property :type,         Enum[ :photo, :video, :journal, :gps, :unknown ]
      property :occurred_at,  Time
      property :duration,     Float
      property :metadata,     Json

      property :created_at,   Time
      property :updated_at,   Time

      has n,    :sequences

    end
    
  end
end
