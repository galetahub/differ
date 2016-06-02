module Differ
  class Line
    STATES = {
      deleted:   0,
      insert:    1,
      changed:   2,
      unchanged: 3
    }.freeze

    attr_reader :index, :state, :value

    def initialize(value, state = :unchanged, index = nil)
      @value = value
      @state = state
      @index = index
    end

    def position
      @position ||= @index + 1
    end

    def state_value
      @state_value ||= STATES[@state]
    end
  end
end
