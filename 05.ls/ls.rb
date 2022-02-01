#!/usr/bin/env ruby
# frozen_string_literal: true

# 出力時の列数
cols = 3
# 列間のスペース数
span = 4

# 親メソッド
def ls(cols, span, dir)
  # アイテムリスト作成
  items = list_items(dir)
  # アイテムリストが空なら終了
  return if items.size.zero?

  # 表作成・出力
  print_items(cols, span, items)
end

# 子メソッド: アイテムリスト作成
def list_items(dir)
  Dir.chdir(dir)
  Dir.children('.').delete_if { |item| item.start_with?('.') }.sort
end

# 子メソッド: 表作成・出力
def print_items(cols, span, items)
  # 出力時の行数を決定
  rows = (items.size.to_f / cols).ceil
  # アイテムリストから転置前の配列を作成
  horizontal_table = items.each_slice(rows).to_a

  # 列の文字数を揃える
  aligned_horizontal_table = horizontal_table.map do |col_data|
    # 最大文字数に合わせて幅を決める
    width = col_data.map(&:size).max + span
    col_data.map { |item| item.ljust(width) }
  end

  # 要素数を揃えて転置
  vertical_table = aligned_horizontal_table.map { |item| item.values_at(0...rows) }.transpose
  # 1行ごとに出力
  vertical_table.each do |row_data|
    row_data.compact.each { |item| print item }
    print "\n"
  end
end

# 1つまでの引数に対応
target = ARGV[0]
if target && File.file?(target)
  # 引数がファイルの時
  puts target
elsif target && File.directory?(target)
  # 引数がディレクトリの時
  ls(cols, span, target)
else
  # 引数なしの時
  ls(cols, span, '.')
end
