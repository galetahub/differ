module Differ
  class Line
    STATES = {
      deleted:   0,
      insert:    1,
      changed:   2,
      unchanged: 3
    }.freeze

    attr_reader :position, :state, :value

    def initialize(value, state = :unchanged, position = nil)
      @value = value
      @state = state
      @position = position
    end

    def state_value
      @state_value ||= STATES[@state]
    end
  end
end
