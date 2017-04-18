require 'pathname'
require_relative 'file_bundle'

module Trackler
  # Implementation is a language-specific implementation of an exercise.
  class Implementation
    IGNORE = [
      Regexp.new("HINTS\.md$"),
      Regexp.new("example", Regexp::IGNORECASE),
      Regexp.new("\/\.$"),
      Regexp.new("/\.meta/")
    ]

    attr_reader :track_id, :repo, :problem, :root, :file_bundle
    attr_writer :files
    def initialize(track_id, repo, problem, root)
      @track_id = track_id
      @repo = repo
      @problem = problem
      @root = Pathname.new(root)
      @file_bundle = FileBundle.new(track_directory, IGNORE)
    end

    def exists?
      File.exist?(track_directory)
    end

    def files
      @files ||= Hash[file_bundle.paths.map {|path|
        [path.relative_path_from(track_directory).to_s, File.read(path)]
      }].merge("README.md" => readme)
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

    def exercise_dir
      if File.exist?(track_dir.join('exercises'))
        File.join('exercises', problem.slug)
      else
        problem.slug
      end
    end

    def git_url
      [repo, "tree/master", exercise_dir].join("/")
    end

    private

    def track_directory
      @track_directory ||= track_dir.join(exercise_dir)
    end

    def track_dir
      @track_dir ||= root.join('tracks', track_id)
    end

    def assemble_readme
      <<-README
# #{readme_title}

#{problem.blurb}

#{readme_body}

#{readme_source}

#{incomplete_solutions_body}
      README
    end

    def readme_title
      problem.name
    end

    def readme_body
      [
        problem.description,
        implementation_hint,
        track_hint,
      ].reject(&:empty?).join("\n").strip
    end

    def readme_source
      problem.source_markdown
    end

    def incomplete_solutions_body
      <<-README
## Submitting Incomplete Problems
It's possible to submit an incomplete solution so you can see how others have completed the exercise.
      README
    end

    def track_hint
      track_hints_filename = track_dir.join('exercises','TRACK_HINTS.md')
      unless File.exist?(track_hints_filename)
        track_hints_filename = track_dir.join('SETUP.md')
      end
      read track_hints_filename
    end

    def implementation_hint
      read File.join(track_directory, 'HINTS.md')
    end

    def read(f)
      if File.exist?(f)
        File.read(f)
      else
        ""
      end
    end
  end
end
