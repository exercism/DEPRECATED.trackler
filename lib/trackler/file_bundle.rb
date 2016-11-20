require 'zip'

module Trackler
  # FileBundle is a zippech archive of a directory.
  class FileBundle
    attr_reader :dir, :ignore_patterns
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
