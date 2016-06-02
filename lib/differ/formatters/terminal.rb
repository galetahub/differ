require 'colorize'
require 'differ/formatters/text'

module Differ
  module Formatters
    class Terminal < Text
      def format_deleted(line)
        super.colorize(:blue)
      end

      def format_insert(line)
        super.colorize(:green)
      end

      def format_changed(line)
        super.colorize(:red)
      end
    end
  end
end
