module Trackler
  class NullMetadata < BasicObject
    def method_missing(*)
      # NOOP
    end

    def respond_to?(*)
      true
    end

    def inspect
      "<null>"
    end

    def exists?
      false
    end

    klass = self
    define_method(:class) { klass }
  end
end
