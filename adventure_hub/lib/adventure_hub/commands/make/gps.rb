module AdventureHub
  module Commands
    module Make
      class Gps < Base

        def initialize(repo, file)
          super(repo)
          @file = file
        end
        
        def perform
          make_resource :gps

          metadata = Util::Metadata::Gps.extract(@file, @repo.shell_runner)
          @resource.occurred_at = metadata.delete(:occurred_at)
          @resource.duration = metadata.delete(:duration)
          @resource.metadata = metadata
          @resource.signature = Util::Signature.quick_signature([@file])

          seq = @resource.sequences.create(name:metadata[:format], source:true)
          disk = @repo.get_mounted_disk_with_space(@file.size)
          resource_file = seq.files.create(disk:disk, extname:@file.extname, size:@file.size)

          destination = @repo.disks_path + resource_file.path
          destination.parent.mkpath
          # copy file into place
          add_child CopySingle.new(@file, destination)

          wait_for_children
          @resource.imported = true
          @resource.save
        end

      end
    end
  end
end
