require 'json'
require 'pathname'
require 'org-ruby'
require 'ostruct'
require_relative 'file_bundle'
require_relative 'doc_file'

module Trackler
  # Track is a collection of exercises in a given language.
  class Track
    TOPICS = %w(about installation tests learning resources)

    Image = Struct.new(:path) do
      def exists?
        File.exist?(path)
      end

      def type
        File.extname(path).sub('.', '').to_sym
      end
    end

    attr_reader :id, :root, :file_bundle
    def initialize(id, root)
      @id = id
      @root = Pathname.new(root)
      @file_bundle = FileBundle.new(dir.join("global"))
    end

    def exists?
      File.exist?(dir)
    end

    def active?
      !!config.active
    end

    def upcoming?
      !active? && implementations.length > 0
    end

    def planned?
      !active? && implementations.length.zero?
    end

    def implementations
      @implementations ||= Implementations.new(repository, active_slugs, root, self)
    end

    def problems
      warn "DEPRECATION WARNING: A track only has implementations, call track.implementations instead"
      implementations
    end

    def checklist_issue
      config.checklist_issue || 1
    end

    def gitter
      config.gitter
    end

    def icon_path
      icon.path if icon.exists?
    end

    def icon
      @icon ||= svg_icon.exists? ? svg_icon : png_icon
    end

    def language
      config.language.to_s.strip
    end

    def repository
      @repository ||= (config.repository || "https://github.com/exercism/%s" % id).to_s.strip
    end

    def test_pattern
      if !!config.test_pattern
        Regexp.new(config.test_pattern)
      else
        /test/i
      end
    end

    def ignore_pattern
      config.ignore_pattern || 'example'
    end

    def docs(image_path: DocFile::DEFAULT_IMAGE_PATH)
      OpenStruct.new(docs_by_topic(image_path))
    end

    def img(file_path)
      Image.new(File.join(dir, file_path))
    end

    def doc_format
      default_format = 'md'
      path = File.join(dir, "docs", "*.*")
      most_popular_format(path) || default_format
    end

    def global_zip
      @zip ||= file_bundle.zip
    end

    # Every slug mentioned in the configuration.
    def slugs
      active_slugs + foregone_slugs + deprecated_slugs
    end

    def dir
      root.join("tracks", id)
    end

    def hints
      path = File.join(dir, 'config', 'exercise-readme-insert.md')
      return File.read(path) if File.exist?(path)
      DocFile.find(basename: 'EXERCISE_README_INSERT', track_dir: dir).render
    end

    private

    def active_slugs
      exercises.reject(&:deprecated).map(&:slug)
    end

    def foregone_slugs
      config.foregone || []
    end

    def deprecated_slugs
      exercises.select(&:deprecated).map(&:slug)
    end

    def most_popular_format(path)
      formats = Dir.glob(path).map do |filename|
        File.extname(filename).sub(/^\./, '')
      end
      formats.max_by { |format| formats.count(format) }
    end

    def exercises
      config.exercises || []
    end

    def config
      @config ||= JSON.parse(File.read(config_filename), object_class: OpenStruct)
    end

    def config_filename
      File.join(dir, "config.json")
    end

    def docs_by_topic(image_path)
      Hash[
        TOPICS.zip(
          TOPICS.map { |topic|
            DocFile.find(basename: topic.upcase, track_dir: dir).render(image_path: image_path)
          }
        )
      ]
    end

    def svg_icon
      @svg_icon ||= Image.new(File.join(dir, "img/icon.svg"))
    end

    def png_icon
      @png_icon ||= Image.new(File.join(dir, "img/icon.png"))
    end
  end
end
