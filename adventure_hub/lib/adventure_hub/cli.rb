module AdventureHub
  class Cli < Thor
    

    desc "watch_for_sources", "looks for any SD cards or USB mounts that could be media sources and then runs acquire on them"
    def watch_for_sources
      Commands::Watch.new.run
    end

    desc "acquire SOURCE", "inspects the provided source and imports any media found at that source"
    def acquire(source_path)
      Commands::Acquire.new(Pathname.new(source_path)).run
    end

  end
end