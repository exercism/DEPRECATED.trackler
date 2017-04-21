require 'pathname'
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
    def_delegators :@problem, :name, :blurb, :description, :source_markdown, :slug, :source, :metadata, :root, :active?, :deprecated?, :source_url, :description_url, :canonical_data_url, :metadata_url

    attr_reader :track
    def initialize(track, problem)
      @track = track
      @problem = problem
    end

    def problem
      warn "DEPRECATION WARNING: The `problem` method is deprecated, Implementation can do everything that Problem can, so call the method directly."
      @problem
    end

    def file_bundle
      @file_bundle ||= FileBundle.new(implementation_dir, regexes_to_ignore)
    end

    def exists?
      File.exist?(implementation_dir)
    end

    def files
      @files ||= Hash[file_bundle.paths.map {|path|
        [path.relative_path_from(implementation_dir).to_s, File.read(path)]
      }].merge("README.md" => readme)
    end

    def files=(value)
      warn "DEPRECATION WARNING: 'Implementation#files=' is no longer public, please use 'implementation.merge_files' instead."
      @files = value
    end

    def merge_files(new_files)
      files.merge!(new_files)
    end

    def zip
      @zip ||= file_bundle.zip do |io|
        io.put_next_entry('README.md')
        io.print readme
      end
    end

    def readme
      @readme ||= assemble_readme
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

    def regexes_to_ignore
      (IGNORE_PATTERNS + [track.ignore_pattern]).map do |pattern|
        Regexp.new(pattern, Regexp::IGNORECASE)
      end
    end

    def implementation_dir
      @implementation_dir ||= track.dir.join(exercise_dir)
    end

    def exercise_dir
      File.join('exercises', problem.slug)
    end

    def assemble_readme
      <<-README
# #{name}

#{readme_body}

#{source_markdown}

#{incomplete_solutions_body}
      README
    end

    def optional_blurb
      return '' if description.start_with?(blurb)
      "#{blurb}\n\n"
    end

    def readme_body
      optional_blurb +
        [
          description,
          implementation_hints,
          track.hints,
        ].reject(&:empty?).join("\n").strip
    end

    def incomplete_solutions_body
      <<-README
## Submitting Incomplete Problems
It's possible to submit an incomplete solution so you can see how others have completed the exercise.
      README
    end

    def implementation_hints
      hints_file = File.join(implementation_dir, 'HINTS.md')
      File.exist?(hints_file) ? File.read(hints_file) : ''
    end
  end
end
