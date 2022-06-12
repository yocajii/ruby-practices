# frozen_string_literal: true

require 'optparse'
require 'pathname'
require_relative 'item'
require_relative 'short_format'
require_relative 'long_format'

class Ls
  def self.main
    options = {}
    opt = OptionParser.new
    opt.on('-a') { |v| options[:a] = v }
    opt.on('-l') { |v| options[:l] = v }
    opt.on('-r') { |v| options[:r] = v }
    target = opt.parse(ARGV)[0] || '.'

    puts new(target, options).show
  end

  def initialize(target, options)
    @target = target
    @options = options
  end

  def show
    items = create_items
    if @options[:l]
      LongFormat.new(items).create_text
    else
      ShortFormat.new(items).create_text
    end
  end

  private

  def create_items
    item_paths =
      if File.file? @target
        [@target]
      else
        names = fetch_item_names(@target)
        trimmed_names = @options[:a] ? names : delete_hidden_item_names(names)
        sorted_names = @options[:r] ? trimmed_names.reverse : trimmed_names
        sorted_names.map { |name| File.join(@target, name) }
      end
    item_paths.map do |item_path|
      Item.new(item_path)
    end
  end

  def fetch_item_names(target)
    Dir.entries(target).sort_by { |name| name.delete_prefix('.').downcase }
  end

  def delete_hidden_item_names(names)
    names.reject { |name| name.start_with?('.') }
  end
end

Ls.main if __FILE__ == $PROGRAM_NAME
