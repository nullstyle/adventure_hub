module AdventureHub
  module Commands
    class Watch
      
      def run()
        search_base = Pathname.new Platforms.current::MOUNT_POINT
        
        perform_initial_search(search_base)
        continually_watch(search_base)

      end
      
      private
      def perform_initial_search(search_base)
        sources = search_base.children.select{|dir| Acquirer.source? dir }
        sources.each{|source| Acquire.new(source).run }
      end
      
      def continually_watch(search_base)
        AH.log "watching for new sources..."
        FSSM.monitor(search_base.realpath, '*', :directories => true) do
          delete {|base, relative, type| }
          update {|base, relative, type| }
        
        
          create do |base, relative, type| 
            pathname = Pathname.new(File.join(base, relative))
          
            Acquire.new(pathname).run if Acquirer.source?(pathname)
          end
        end
      end
      
      
    end
  end
end
