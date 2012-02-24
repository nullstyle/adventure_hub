module AdventureHub
  class Cli < Thor
    desc "watch_for_sources REPO_PATH", "looks for any SD cards or USB mounts that could be media sources and then runs acquire on them"
    def watch_for_sources(repo_path)
      repo = Repository.new Pathname.new(repo_path)
      run_root_command Commands::Watch.new repo
    end

    desc "acquire SOURCE REPO_PATH", "inspects the provided source and imports any media found at that source"
    def acquire(source_path, repo_path)
      repo = Repository.new Pathname.new(repo_path)
      run_root_command Commands::Acquire.new(Pathname.new(source_path))
    end


    desc "copy SOURCE DEST", "inspects the provided source and imports any media found at that source"
    def copy(source_path, dest_path)
      
      command = Commands::BatchCopy.new
      command.cp Pathname.new(source_path), Pathname.new(dest_path + ".1")
      command.cp Pathname.new(source_path), Pathname.new(dest_path + ".2")
      command.cp Pathname.new(source_path), Pathname.new(dest_path + ".3")
      command.cp Pathname.new(source_path), Pathname.new(dest_path + ".4")
      command.cp Pathname.new(source_path), Pathname.new(dest_path + ".5")
      command.cp Pathname.new(source_path), Pathname.new(dest_path + ".6")
      command.cp Pathname.new(source_path), Pathname.new(dest_path + ".7")
      command.cp Pathname.new(source_path), Pathname.new(dest_path + ".8")

      run_root_command command
    end

    private
    def run_root_command(command)
      command.execute!
      AH.wait_for_actor(command)
    end

  end
end