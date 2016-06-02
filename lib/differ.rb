require 'pathname'
require 'differ/version'

module Differ
  module Formatters
  end

  def self.root_path
    @root_path ||= Pathname.new(File.dirname(File.expand_path('../', __FILE__)))
  end
end

require 'differ/line'
require 'differ/formatters/html'
require 'differ/formatters/terminal'
require 'differ/formatters/text'
require 'differ/broker'
