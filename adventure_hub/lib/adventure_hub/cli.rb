module AdventureHub
  class Cli < Thor
    desc "watch_for_sources", "looks for any SD cards or USB mounts that could be media sources and then runs acquire on them"
    def watch_for_sources
      prepare_run
      run_root_command Commands::Watch.new
    end

    desc "acquire SOURCE", "inspects the provided source and imports any media found at that source"
    def acquire(source_path)
      prepare_run
      run_root_command Commands::Acquire.new(Pathname.new(source_path))
    end

    private
    def run_root_command(command)
      command.execute!
      AH.wait_for_actor(command)
    end

    def prepare_run

    end
  end
end