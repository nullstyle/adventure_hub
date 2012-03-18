module AdventureHub
  class Resource

    attr_reader :repo

    attr_reader :path
    attr_reader :metadata
    attr_reader :created_at
    attr_reader :updated_at
    attr_reader :occurred_at
    attr_reader :duration

    def initialize(repo)
      @repo = repo
    end


  end
end
