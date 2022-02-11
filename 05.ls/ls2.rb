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
    if target && File.file?(target)
      puts target
      return
    end
    items = list_items(target)
    items = items.delete_if { |item| item.start_with?('.') } unless options[:a]
    items = items.reverse if options[:r]
    return if items.size.zero?

    table =
      if options[:l]
        generate_long_table(items)
      else
        generate_short_table(items)
      end
    print_table(table)
  end

  private

  def list_items(dir)
    Dir.chdir(dir)
    Dir.entries('.').sort_by { |v| v.match('^[.]?(.*$)')[1] }
  end

  def print_table(table)
    table.each do |row_data|
      row_data.compact.each { |item| print item }
      print "\n"
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
