module Roro
  class Error < StandardError; end

  module Story
    class StoryMissing < Error; end
  end

  module Crypto
    class KeyError             < Error; end

    class EnvironmentError     < Error; end

    class DataDestructionError < Error; end

    class EncryptableError     < Error; end

    class DecryptableError     < Error; end
  end
end
