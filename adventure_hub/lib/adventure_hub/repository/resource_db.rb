require 'sequel'
Sequel.extension :migration

module AdventureHub
  class Repository


    class ResourceDB
      # include Celluloid
      
      def initialize(repo)
        @repo = repo
        @db = Sequel.sqlite(repo.resource_db_path.to_s)
        prepare_db
      end

      private
      def prepare_db
        Sequel::Migrator.run(@db, File.dirname(__FILE__) + "/migrations")
      end
    end
  end
end