#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class Ls
  COLS = 3 # 列数
  SPAN = 2 # 列間のスペース数

  def show(target, options)
    if target && File.file?(target)
      puts target
      return
    end
    items = list_items(target)
    items = items.delete_if { |item| item.start_with?('.') } unless options[:a]
    return if items.size.zero?

    vertical_table = generate_table(items)
    print_table(vertical_table)
  end

  private

  def list_items(dir)
    Dir.chdir(dir)
    Dir.entries('.').sort_by { |v| v.match('^[.]?(.*$)')[1] }
  end

  def generate_table(items)
    rows = (items.size.to_f / COLS).ceil
    horizontal_table = items.each_slice(rows).to_a
    aligned_horizontal_table = horizontal_table.map do |col_data|
      width = col_data.map(&:size).max + SPAN
      col_data.map { |item| item.ljust(width) }
    end
    aligned_horizontal_table.map { |item| item.values_at(0...rows) }.transpose
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
target = opt.parse(ARGV)[0] # ファイル/ディレクトリ指定2つ目以降は無視

ls = Ls.new
ls.show(target || '.', options)
