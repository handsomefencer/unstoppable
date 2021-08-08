module Roro
  class Error < StandardError; end

  module Catalog
    class Keys < Error; end
    class Empty < Error; end
    class Story < Error; end
    class OutlineError < Error; end
    class StoryError < Error; end
    class KeyError < Error; end
  end

  module Crypto
    class KeyError             < Error; end

    class EnvironmentError     < Error; end

    class DataDestructionError < Error; end

    class EncryptableError     < Error; end

    class DecryptableError     < Error; end
  end
end
