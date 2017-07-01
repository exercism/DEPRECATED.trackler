module Trackler
  # Specifications is the collection of problems that we have metadata for.
  class Specifications
    include Enumerable

    attr_reader :root
    def initialize(root)
      @root = root
    end

    def each
      active.each do |specification|
        yield specification
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
      @all_specifications ||= exercise_slugs.map { |slug| Specification.new(slug, root) }
    end

    def exercise_slugs
      Dir["%s/problem-specifications/exercises/*/" % root].map { |path| File.basename(path) }.sort
    end

    def by_slug
      @by_slug ||= specification_map
    end

    def specification_map
      hash = Hash.new { |_, k| Specification.new(k, root) }
      active.each do |specification|
        hash[specification.slug] = specification
      end
      hash
    end
  end
end
