
module Roro

  class CLI < Thor

    desc 'omakase::roro', 'Generates roro in your mise'

    map 'omakase::roro' => 'omakase_roro'

    def omakase_roro
      greenfield({ story: :roro })
    end
  end
end
