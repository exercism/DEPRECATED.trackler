module Trackler
  # Implementations is a collection of exercises in a specific language track.
  class Implementations
    include Enumerable

    attr_reader :repo, :slugs, :root, :track
    def initialize(repo, slugs, root, track)
      @repo = repo
      @slugs = slugs
      @root = root
      @track = track
    end

    def each
      all.each do |implementation|
        yield implementation
      end
    end

    def [](slug)
      by_slug[slug]
    end

    private

    def all
      @all ||= slugs.map { |slug|
        Implementation.new(track, Problem.new(slug, root, track))
      }
    end

    def by_slug
      @by_slug ||= implementation_map
    end

    def implementation_map
      hash = Hash.new { |_, k|
        Implementation.new(track, Problem.new(k, root, track))
      }
      all.each do |impl|
        hash[impl.problem.slug] = impl
      end
      hash
    end
  end
end
