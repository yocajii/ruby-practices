#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

def print_calendar(year, month, current_day)
  # 年月・曜日を出力
  puts "      #{month.to_s.rjust(2)}月 #{year}"
  puts '日 月 火 水 木 金 土'
  # 日付の開始位置調整
  Date.new(year, month, 1).wday.times { print '   ' }
  # 末日
  last_day = Date.new(year, month, -1).day
  # 日付出力
  (1..last_day).each do |day|
    # 日付を2桁に揃える
    day_string = day.to_s.rjust(2)
    if current_day == day
      # 当日なら表示色反転して出力
      print "\e[7m#{day_string}\e[0m "
    else
      # 当日以外は反転せず出力
      print "#{day_string} "
    end
    # 土曜日なら改行
    puts '' if Date.new(year, month, day).saturday?
  end
end

# 年月デフォルト値
today = Date.today
today_year = today.year
today_month = today.month

# 年月指定
options = ARGV.getopts('y:m:')
year = if options['y']
         options['y'].to_i
       else
         today_year
       end
month = if options['m']
          options['m'].to_i
        else
          today_month
        end
# 当年当月なら当日を設定
current_day = (today.day if year == today_year && month == today_month)

print_calendar(year, month, current_day)
