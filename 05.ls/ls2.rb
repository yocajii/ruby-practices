#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLS = 3 # 列数
SPAN = 2 # 列間のスペース数

# 親メソッド
def ls(dir, options)
  items = if options[:a]
            list_items(dir)
          else
            list_items(dir).delete_if { |item| item.start_with?('.') }
          end
  return if items.size.zero?

  print_items(items)
end

# 子メソッド: アイテムリスト作成
def list_items(dir)
  Dir.chdir(dir)
  Dir.entries('.').sort
end

# 子メソッド: 表作成・出力
def print_items(items)
  rows = (items.size.to_f / COLS).ceil
  horizontal_table = items.each_slice(rows).to_a

  aligned_horizontal_table = horizontal_table.map do |col_data|
    width = col_data.map(&:size).max + SPAN
    col_data.map { |item| item.ljust(width) }
  end

  vertical_table = aligned_horizontal_table.map { |item| item.values_at(0...rows) }.transpose
  vertical_table.each do |row_data|
    row_data.compact.each { |item| print item }
    print "\n"
  end
end

options = {}
opt = OptionParser.new
opt.on('-a') { |v| options[:a] = v }
# ファイル/ディレクトリ指定1つまで対応
target = opt.parse(ARGV)[0]

if target && File.file?(target)
  puts target
else
  ls(target || '.', options)
end
