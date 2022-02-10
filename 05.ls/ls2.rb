#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'ls_short'

class Ls
  include LsShort

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

    vertical_table = generate_table(items)
    print_table(vertical_table)
  end

  private

  def list_items(dir)
    Dir.chdir(dir)
    Dir.entries('.').sort_by { |v| v.match('^[.]?(.*$)')[1] }
  end
end

options = {}
opt = OptionParser.new
opt.on('-a') { |v| options[:a] = v }
opt.on('-r') { |v| options[:r] = v }
target = opt.parse(ARGV)[0] # ファイル/ディレクトリ指定2つ目以降は無視

Ls.show(target || '.', options)
