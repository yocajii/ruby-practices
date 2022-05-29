# frozen_string_literal: true

require 'optparse'
require 'pathname'
require_relative 'item'
require_relative 'short_format'
require_relative 'long_format'

class Ls
  def initialize(target, options)
    @target = target
    @options = options
  end

  def show
    items = fetch_items
    if @options[:l]
      LongFormat.new(items).create_text
    else
      ShortFormat.new(items).create_text
    end
  end

  private

  def fetch_items
    item_names =
      if File.file? @target
        [@target]
      else
        names = sort_all_items(@target)
        names = delete_hidden_items(names) unless @options[:a]
        names = names.reverse if @options[:r]
        names
      end
    item_names.map do |item_name|
      item_path = Pathname(@target).join(item_name)
      Item.new(item_name, item_path)
    end
  end

  def sort_all_items(target)
    Dir.entries(target).sort_by { |name| name.delete_prefix('.') }
  end

  def delete_hidden_items(names)
    names.delete_if { |name| name.start_with?('.') }
  end
end

def main
  options = {}
  opt = OptionParser.new
  opt.on('-a') { |v| options[:a] = v }
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-r') { |v| options[:r] = v }
  target = opt.parse(ARGV)[0] || '.'

  puts Ls.new(target, options).show
end

if __FILE__ == $PROGRAM_NAME
  main
end
