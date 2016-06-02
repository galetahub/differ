# encoding: utf-8
$stdout.sync = true
$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)

require 'singleton'
require 'optparse'

require 'differ'

module Differ
  class CLI
    include Singleton

    def initialize
      @options = { formatter: Differ::Formatters::Terminal }
    end

    def parse(args = ARGV)
      @options = parse_options(args)
      raise 'Please, provide at least two files for compare' if @options[:files].size < 2
    end

    def run
      string1 = File.read(@options[:files][0])
      string2 = File.read(@options[:files][1])

      broker = Differ::Broker.new(string1, string2, @options)
      broker.compare
      puts broker.comparison
    end

    def parse_options(argv)
      options = { files: [] }

      @parser = OptionParser.new do |o|
        o.on '-f', '--file path', 'Path to file' do |arg|
          options[:files] << arg
        end

        o.on '-V', '--version', 'Print version and exit' do
          puts "Differ #{Differ::VERSION}"
          exit(0)
        end
      end

      @parser.banner = 'differ [options]'
      @parser.on_tail '-h', '--help', 'Show help' do
        puts @parser
        exit(1)
      end

      @parser.parse!(argv)

      options
    end
  end
end
