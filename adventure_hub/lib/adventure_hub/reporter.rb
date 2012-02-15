module AdventureHub
  class Reporter
    
    include Celluloid

    def log(message)
      puts message
    end
    
  end
end