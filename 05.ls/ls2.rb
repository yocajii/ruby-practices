#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'ls_short'
require_relative 'ls_long'

class Ls
  include LsShort
  include LsLong

  def self.show(target, options)
    new.show(target, options)
  end

  def show(target, options)
    items = list_items(target)
    items = items.delete_if { |item| item.start_with?('.') } unless options[:a]
    items = items.reverse if options[:r]
    if options[:l]
      show_long_data(items)
    else
      return if items.size.zero?

      show_short_data(items)
    end
  end

  private

  def list_items(target)
    if File.file?(target)
      [target]
    else
      Dir.chdir(target)
      Dir.entries('.').sort_by { |v| v.match('^[.]?(.*$)')[1] }
    end
  end
end

options = {}
opt = OptionParser.new
opt.on('-a') { |v| options[:a] = v }
opt.on('-l') { |v| options[:l] = v }
opt.on('-r') { |v| options[:r] = v }
target = opt.parse(ARGV)[0] # ファイル/ディレクトリ指定2つ目以降は無視

Ls.show(target || '.', options)
