module Trackler
  class Metadata
    attr_accessor :file

    def self.for_problem(problem:)
      metadata = new
      path = File.join(problem.root, "common", "exercises/%s/metadata.yml" % problem.slug)

      metadata.file = if File.exists?(path)
                        YAML.load(File.read(path))
                      end
      metadata
    end

    def blurb
      file['blurb'].to_s.strip
    end

    def source
      file['source'].to_s.strip
    end

    def source_url
      file['source_url'].to_s.strip
    end

    def exists?
      !file.nil?
    end
  end
end
