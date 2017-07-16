require 'pathname'
require 'forwardable'
require_relative 'file_bundle'

module Trackler
  # Implementation is a language-specific implementation of an exercise.
  class Implementation
    IGNORE_PATTERNS = [
      "\/HINTS\.md$",
      "\/\.$",
      "/\.meta/"
    ]

    extend Forwardable
    def_delegators :@specification, :name, :blurb, :description, :source_markdown, :slug, :source, :metadata, :root, :active?, :deprecated?, :source_url, :description_url, :canonical_data_url, :metadata_url
    def_delegators :@track, :language

    def initialize(track, specification)
      @track = track
      @specification = specification
    end

    def initialize_copy(original)
      super
      @files = original.files.dup
    end

    def problem
      warn "DEPRECATION WARNING: The `problem` method is deprecated, Implementation can do everything that Problem can, so call the method directly."
      @specification
    end

    def exists?
      File.exist?(implementation_dir)
    end

    def files
      @files ||= Hash[file_bundle.paths.map {|path|
        [path.relative_path_from(implementation_dir).to_s, File.read(path)]
      }].merge("README.md" => readme)
    end

    def zip
      @zip ||= file_bundle.zip do |io|
        io.put_next_entry('README.md')
        io.print readme
      end
    end

    def readme
      @readme ||= static_readme || assemble_readme
    end

    def git_url
      [track.repository, "tree/master", exercise_dir].join("/")
    end

    # DEPRECATED: We changed the class to hold on to a
    # track object, however downstream dependencies send the
    # to the track_id message.
    def track_id
      track.id
    end

    private

    attr_reader :track

    def regexes_to_ignore
      (IGNORE_PATTERNS + [track.ignore_pattern]).map do |pattern|
        Regexp.new(pattern, Regexp::IGNORECASE)
      end
    end

    def file_bundle
      @file_bundle ||= FileBundle.new(implementation_dir, regexes_to_ignore)
    end

    def implementation_dir
      @implementation_dir ||= track.dir.join(exercise_dir)
    end

    def exercise_dir
      File.join('exercises', slug)
    end

    def static_readme
      path = File.join(implementation_dir, 'README.md')
      return File.read(path) if File.exist?(path)
    end

    def assemble_readme
      <<-README
# #{name}

#{readme_body}

#{source_markdown}

#{incomplete_solutions_body}
      README
    end

    def readme_body
        [
          description,
          implementation_hints,
          track.hints,
        ].reject(&:empty?).join("\n").strip
    end

    def incomplete_solutions_body
      <<-README
## Submitting Incomplete Solutions
It's possible to submit an incomplete solution so you can see how others have completed the exercise.
      README
    end

    def implementation_hints
      [File.join('.meta', 'hints.md'), 'HINTS.md'].each do |filename|
        path = File.join(implementation_dir, filename)
        return File.read(path) if File.exist?(path)
      end
      ""
    end
  end
end
