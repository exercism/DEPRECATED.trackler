module Trackler
  class NullTrack < BasicObject
    def method_missing(*)
      # NOOP
    end

    def respond_to?(*)
      true
    end

    def inspect
      "<null>"
    end

    def id
      ""
    end

    klass = self
    define_method(:class) { klass }
  end
end
