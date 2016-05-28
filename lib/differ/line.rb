module Differ
  class Line
    STATES = {
      delete:    0,
      insert:    1,
      changed:   2,
      unchanged: 3
    }.freeze

    def initialize
      @position = 1
      @value = ''
      @state = 0
    end

    def state_name
      @state_name ||= STATES.key(@state)
    end
  end
end
