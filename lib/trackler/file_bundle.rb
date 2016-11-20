require 'zip'

module Trackler
  # A FileBundle is a collection of files from within an exercise directory
  # It contains all the files that will be provided by the `exercism fetch` command
  # EXCEPT for those whose names match any of the ignore patterns.
  class FileBundle
    def initialize(dir, ignore_patterns = [])
      @dir = dir
      @ignore_patterns = ignore_patterns
    end

    def zip
      Zip::OutputStream.write_buffer do |io|
        paths.each do |path|
          io.put_next_entry(path.relative_path_from(dir))
          io.print IO.read(path)
        end
        yield io if block_given?
      end
    end

    def paths
      all_files_below(dir).reject { |file| ignored? file }.sort
    end

    private

    attr_reader :dir, :ignore_patterns

    def all_files_below(dir)
      Pathname.glob("#{dir}/**/*", File::FNM_DOTMATCH)
    end

    def ignored?(file)
      ignored_by_name?(file) || ignored_by_type?(file)
    end

    def ignored_by_name?(file)
      ignore_patterns.any? { |pattern| file.to_s =~ pattern }
    end

    def ignored_by_type?(file)
      file.directory?
    end
  end
end
