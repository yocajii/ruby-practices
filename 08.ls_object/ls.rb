# frozen_string_literal: true

require 'optparse'
require_relative 'item'
require_relative 'short_format'
require_relative 'long_format'

class Ls
  def initialize(target, options)
    @target = target
    @options = options
    @items = fetch_items
  end

  def show
    if @options[:l]
      puts LongFormat.new(@items).text
    else
      return if @items.size.zero?

      puts ShortFormat.new(@items).text
    end
  end

  private

  def fetch_items
    item_names =
      if File.file? @target
        [@target]
      else
        @names = bulk_names
        trim_names unless @options[:a]
        reverse_names if @options[:r]
        @names
      end
    item_names.map { |name| Item.new(name) }
  end

  def bulk_names
    Dir.chdir(@target)
    Dir.entries('.').sort_by { |v| v.match('^[.]?(.*$)')[1] }
  end

  def trim_names
    @names.delete_if { |name| name.start_with?('.') }
  end

  def reverse_names
    @names.reverse!
  end
end

options = {}
opt = OptionParser.new
opt.on('-a') { |v| options[:a] = v }
opt.on('-l') { |v| options[:l] = v }
opt.on('-r') { |v| options[:r] = v }
target = opt.parse(ARGV)[0] || '.'

Ls.new(target, options).show
