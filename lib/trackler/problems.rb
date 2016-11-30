module Trackler
  # Problems is the collection of problems that we have metadata for.
  class Problems
    include Enumerable

    attr_reader :root
    def initialize(root)
      @root = root
    end

    def each
      active.each do |problem|
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

    def active
      @active ||= all.select(&:active?)
    end

    def all
      @all_problems ||= exercise_slugs.map { |slug| Problem.new(slug, root) }
    end

    def exercise_slugs
      Dir["%s/common/exercises/*/" % root].map { |path| File.basename(path) }.sort
    end

    def by_slug
      @by_slug ||= problem_map
    end

    def problem_map
      hash = Hash.new { |_, k| Problem.new(k, root) }
      active.each do |problem|
        hash[problem.slug] = problem
      end
      hash
    end
  end
end
