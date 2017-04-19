require 'zip'

module Trackler
  # A FileBundle is a collection of files from within an exercise directory
  # It contains all the files that will be provided by the `exercism fetch` command
  # EXCEPT for those whose names match any of the ignore patterns.
  class FileBundle
    def initialize(base_directory, ignore_patterns = [], keep_pattern = nil)
      @base_directory = base_directory
      @ignore_patterns = ignore_patterns
      @keep_pattern = keep_pattern
    end

    def zip
      Zip::OutputStream.write_buffer do |io|
        paths.each do |path|
          io.put_next_entry(path.relative_path_from(base_directory))
          io.print IO.read(path)
        end
        yield io if block_given?
      end
    end

    def paths
      all_files_below(base_directory).reject { |file| ignored? file }.sort
    end

    private

    attr_reader :base_directory, :ignore_patterns, :keep_pattern

    def all_files_below(dir)
      Pathname.glob("#{dir}/**/*", File::FNM_DOTMATCH)
    end

    def ignored?(file)
      name = file.to_s.gsub(base_directory.to_s, "")
      ignored_by_type?(file) || (!keep?(name) && ignored_by_name?(name))
    end

    def keep?(filename)
      (!!keep_pattern && filename =~ keep_pattern)
    end

    def ignored_by_name?(filename)
      ignore_patterns.any? { |pattern| filename =~ pattern }
    end

    def ignored_by_type?(file)
      file.directory?
    end
  end
end
