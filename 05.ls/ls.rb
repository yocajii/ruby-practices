#!/usr/bin/env ruby
# frozen_string_literal: true

# 出力時の列数
cols = 3
# 列間のスペース数
span = 4

# アイテムリスト
items = Dir.children('.').delete_if { |item| item.start_with?('.') }.sort
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
