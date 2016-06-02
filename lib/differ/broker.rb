module Differ
  class Broker
    def initialize(string1, string2, options = {})
      @string1 = string1
      @string2 = string2
      @options = options
    end

    def lines
      @lines ||= []
    end

    def build_line(value, state)
      lines << Line.new(value, state, lines.length)
      state
    end

    def compare
      each_compare_lines do |left, right|
        if left == right
          build_line(left, :unchanged)
        elsif left.nil? && !right.nil?
          build_line(right, :insert)
        elsif right.nil?
          build_line(left, :deleted)
        else
          compare_changed(left, right)
        end
      end
    end

    def comparison
      formatter_klass.new(lines).format
    end

    protected

    def left_lines
      @left_lines ||= @string1.lines.dup
    end

    def right_lines
      @right_lines ||= @string2.lines.dup
    end

    def total_lines_count
      left_lines.length + right_lines.length
    end

    def formatter_klass
      (@options[:formatter] || Differ::Formatters::Terminal)
    end

    def each_compare_lines
      while total_lines_count > 0
        left = left_lines.shift
        right = right_lines.shift

        result = yield(left, right)
        right_lines.unshift(right) if !right.nil? && result == :deleted
      end
    end

    def compare_changed(left, right)
      if right_include?(left)
        build_line(right, :insert)
      elsif left_include?(right)
        build_line(left, :deleted)
      else
        build_line(left + '|' + right, :changed)
      end
    end

    def right_include?(value)
      right_lines.include?(value)
    end

    def left_include?(value)
      left_lines.include?(value)
    end
  end
end
