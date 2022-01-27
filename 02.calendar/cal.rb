# frozen_string_literal: true

require 'date'

base_date = Date.new(2022, 1, 1)     # 基準にするDateオブジェクト
last_day = Date.new(2022, 1, -1).day # 末日
first_wday = base_date.wday          # 1日の曜日
year = base_date.year
month = base_date.month

# ヘッダ出力
puts "     #{month}月 #{year}"
puts '日 月 火 水 木 金 土'
# 日付の開始位置調整
first_wday.times do
  print '   '
end
# 日付出力
(1..last_day).each do |day|
  print ' ' if day < 10
  print "#{day} "
  puts '' if Date.new(2022, 1, day).saturday?
end
