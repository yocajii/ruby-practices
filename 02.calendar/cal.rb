#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

# 年月デフォルト値
today = Date.today
year = today.year
month = today.month

# 引数による年月指定
options = ARGV.getopts('y:m:')
year = options['y'].to_i if options['y']
month = options['m'].to_i if options['m']

# 1日の曜日
first_wday = Date.new(year, month, 1).wday
# 末日
last_day = Date.new(year, month, -1).day

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
  # 土曜日なら改行
  puts '' if Date.new(year, month, day).saturday?
end
