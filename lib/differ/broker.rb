module Differ
  class Broker
    def initialize(string1, string2, options = {})
      @string1 = string1
      @string2 = string2
      @options = options
    end

    def formatter
      @formatter ||= formatter_klass.new
    end

    protected

    def formatter_klass
      (@options[:formatter] || Differ::Formatters::Terminal)
    end
  end
end
