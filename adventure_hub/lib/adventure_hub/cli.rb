module AdventureHub
  class Cli < Thor
    desc "watch_for_sources", "looks for any SD cards or USB mounts that could be media sources and then runs acquire on them"
    def watch_for_sources
      repo = get_repository
      run_root_command Commands::Watch.new repo
    end

    desc "acquire SOURCE", "inspects the provided source and imports any media found at that source"
    def acquire(source_path)
      repo = get_repository
      run_root_command Commands::Acquire.new(repo, Pathname.new(source_path))
    end

    desc "process_incoming PATH", "looks at the provided incoming folder and imports any resources within"
    def process_incoming(path)
      repo = get_repository
      run_root_command Commands::ProcessIncoming.new(repo, Pathname.new(path))
    end

    desc "init TYPE PATH", "creates a new ahub repository"
    def init(type, path)
      case type
      when "repo" ; Repository.create(Pathname.new(path))
      when "disk" ;
        repo = get_repository
        Models::Disk.init(Pathname.new(path))
      end
    end

    desc "repl", "start a repl"
    def repl
      repo = get_repository
      repl = Repl.new repo
      repl.start
    end

    desc "curate", "starts up the curation server"
    def curate
      repo = get_repository
      server = Servers::Curate.run! repo: repo
    end

    private
    def run_root_command(command)
      command.execute!
      AH.wait_for_actor(command)
    end

    def find_repository_path
      root = Pathname.new("/")
      current = Pathname.new Dir.pwd
      
      loop do
        return current if Repository.repository?(current)
        return nil if current == root
        current = current.parent
      end
    end

    def get_repository
      repo_path = find_repository_path
      unless repo_path
        puts "cannot find a repo"
        exit 1
      end

      Repository.new repo_path
    end

  end
end