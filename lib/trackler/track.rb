require 'json'
require 'pathname'
require 'org-ruby'
require 'ostruct'
require_relative 'file_bundle'

module Trackler
  # Track is a collection of exercises in a given language.
  class Track
    TOPICS = %w(about installation tests learning resources)
    DEFAULT_IMAGE_PATH = "/docs/img"

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
      !!config["active"]
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
      config.fetch("checklist_issue", 1)
    end

    def gitter
      config["gitter"]
    end

    def icon_path
      icon.path if icon.exists?
    end

    def icon
      @icon ||= svg_icon.exists? ? svg_icon : png_icon
    end

    def language
      config['language'].to_s.strip
    end

    def repository
      config['repository'].to_s.strip
    end

    def test_pattern
      if config.key?('test_pattern')
        Regexp.new(config['test_pattern'])
      else
        /test/i
      end
    end

    def ignore_pattern
      config.fetch('ignore_pattern', 'example')
    end

    def docs(positional_image_path_which_is_deprecated = nil, image_path: nil)
      if positional_image_path_which_is_deprecated
        warn "DEPRECATION WARNING:\ntrack.docs: Positional argument is deprecated, please use keyword argument 'image_path:' instead\neg: track.docs(image_path: #{positional_image_path_which_is_deprecated.inspect})\n"
      end
      OpenStruct.new(docs_by_topic(image_path || positional_image_path_which_is_deprecated || DEFAULT_IMAGE_PATH))
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
      if File.exist?(track_hints_filename)
        File.read(track_hints_filename)
      else
        ""
      end
    end

    private

    def track_hints_filename
      File.join(dir, 'docs', 'EXERCISE_README_INSERT.md')
    end

    def active_slugs
      (config["exercises"] || []).map { |ex| ex["slug"] }
    end

    def foregone_slugs
      config["foregone"] || []
    end

    def deprecated_slugs
      config["deprecated"] || []
    end

    def most_popular_format(path)
      formats = Dir.glob(path).map do |filename|
        File.extname(filename).sub(/^\./, '')
      end
      formats.max_by { |format| formats.count(format) }
    end

    def config
      @config ||= JSON.parse(File.read(config_filename))
    end

    def config_filename
      File.join(dir, "config.json")
    end

    def document_contents(topic)
      filename = document_filename(topic)
      case filename
      when /\.md$/
        File.read(filename)
      when /\.org$/
        Orgmode::Parser.new(File.read(filename)).to_markdown
      else
        ''
      end
    end

    def docs_by_topic(image_path)
      src = Regexp.new("]\\(%s" % DEFAULT_IMAGE_PATH)
      dst = "](%s" % image_path.gsub(Regexp.new("/$"), "")
      Hash[
        TOPICS.zip(
          TOPICS.map { |topic|
            document_contents(topic).gsub(src, dst)
          }
        )
      ]
    end

    def document_filename(topic)
      path = File.join(dir, "docs", topic.upcase)
      Dir.glob("%s.*" % path).sort.first
    end

    def svg_icon
      @svg_icon ||= Image.new(File.join(dir, "img/icon.svg"))
    end

    def png_icon
      @png_icon ||= Image.new(File.join(dir, "img/icon.png"))
    end
  end
end
