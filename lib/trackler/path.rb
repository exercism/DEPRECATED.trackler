module Trackler
  module Path
    def self.root
      File.expand_path("../../../", __FILE__).freeze
    end

    def self.fixtures
      File.expand_path("../../../fixtures", __FILE__).freeze
    end
  end
end
