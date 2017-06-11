class DocFile
  DEFAULT_IMAGE_PATH = "/docs/img"

  def self.find(basename:, track_dir:)
    dir = File.join(track_dir, "docs")

    [
      MarkdownFile.new(basename: basename, docs_dir: dir),
      OrgmodeFile.new(basename: basename, docs_dir: dir),
    ].detect(&:exist?) || NullFile.new(basename: basename, docs_dir: dir)
  end

  attr_reader :basename, :dir
  def initialize(basename:, docs_dir:)
    @basename = basename
    @dir = docs_dir
  end

  def render(image_path: DEFAULT_IMAGE_PATH)
    body.gsub(img_src, img_dst(image_path))
  end

  def name
    "%s.%s" % [basename, extension]
  end

  def extension
    "md"
  end

  def exist?
    File.exist?(path)
  end

  private

  def body
    File.read(path)
  end

  def path
    File.join(dir, name)
  end

  def img_src
    Regexp.new("]\\(%s" % DEFAULT_IMAGE_PATH)
  end

  def img_dst(image_path)
    "](%s" % image_path.gsub(Regexp.new("/$"), "")
  end
end

class OrgmodeFile < DocFile
  def body
    Orgmode::Parser.new(File.read(path)).to_markdown
  end

  def extension
    "org"
  end
end

class MarkdownFile < DocFile
end

class NullFile < DocFile
  def render(image_path:"")
    ""
  end

  def exist?
    false
  end
end
