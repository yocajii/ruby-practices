#!/usr/bin/env ruby
# frozen_string_literal: true

# 出力時の列数
COLS = 3
# 列間のスペース数
SPAN = 4

# 親メソッド
def ls(dir)
  items = list_items(dir)
  return if items.size.zero?

  print_items(items)
end

# 子メソッド: アイテムリスト作成
def list_items(dir)
  Dir.chdir(dir)
  Dir.children('.').delete_if { |item| item.start_with?('.') }.sort
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

# 1つまでの引数に対応
target = ARGV[0]
if target && File.file?(target)
  puts target
else
  ls(target || '.')
end
