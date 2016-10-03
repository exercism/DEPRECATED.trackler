module Trackler
  # Problems is the collection of problems that we have metadata for.
  class Problems
    include Enumerable

    SLUG_PATTERN = Regexp.new(".*\/exercises\/([^\/]*)\/")

    attr_reader :root
    def initialize(root)
      @root = root
    end

    def each
      all.each do |problem|
        yield problem
      end
    end

    def [](slug)
      by_slug[slug]
    end

    # rubocop:disable Style/OpMethod
    def -(slugs)
      (by_slug.keys - slugs).sort
    end

    private

    def all
      @all ||= dirs.reject { |problem| deprecated?(problem.slug) }
    end

    def dirs
      @exercise_ids ||= Dir["%s/common/exercises/*/" % root].sort.map { |f|
        Problem.new(f[SLUG_PATTERN, 1], root)
      }
    end

    def deprecated?(slug)
      File.exist?(File.join(root, "common", "exercises", slug, ".deprecated"))
    end

    def by_slug
      @by_slug ||= problem_map
    end

    def problem_map
      hash = Hash.new { |_, k| Problem.new(k, root) }
      all.each do |problem|
        hash[problem.slug] = problem
      end
      hash
    end
  end
end
