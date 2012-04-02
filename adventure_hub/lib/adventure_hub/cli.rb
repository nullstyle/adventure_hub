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

    desc "init PATH", "creates a new ahub repository"
    def init(path=".")
      Repository.create(Pathname.new(path))
    end

    desc "repl PATH", "creates a new ahub repository"
    def repl(repo_path=nil)
      repo = Repository.new Pathname.new(repo_path) if repo_path
      repl = Repl.new repo
      repl.start
    end

    desc "curate PATH", "starts up the curation server"
    def curate(repo_path)
      repo = Repository.new Pathname.new(repo_path)
      server = Servers::Curate.run! repo: repo
    end

    private
    def run_root_command(command)
      command.execute!
      AH.wait_for_actor(command)
    end

  end
end