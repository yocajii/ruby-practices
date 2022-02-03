#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数を取得
score = ARGV[0]

scores = score.split(',')
shots = []
while scores.any?
  shot = scores.shift
  if shot == 'X' && shots.size < 18
    # 9フレーム目までのストライク
    shots << 10
    shots << 0
  elsif shot == 'X'
    # 10フレーム目のストライク
    shots << 10
  else
    shots << shot.to_i
  end
end

# フレームに分ける
frames = []
shots.each_slice(2) do |s|
  frames << s
end
# 最終フレームが3投ならフレームを結合する
frames[-2].push frames.pop[0] if frames[-1].size == 1

point = 0
# 最後のフレーム以外の得点計算
9.times do |i|
  point += if frames[i][0] == 10 # strike
             # 次フレームもストライクの時
             if frames[i + 1][0] == 10
               if i < 8 # 8フレーム目までの時
                 frames[i].sum + frames[i + 1][0] + frames[i + 2][0]
               else # 9フレーム目の時
                 frames[i].sum + frames[i + 1][0] + frames[i + 1][1]
               end
               # 次フレームはストライクではないとき
             else
               frames[i].sum + frames[i + 1][0] + frames[i + 1][1]
             end
           elsif frames[i].sum == 10 # spare
             frames[i].sum + frames[i + 1][0]
           else
             frames[i].sum
           end
end
# 最後のフレームは単純に加算
point += frames[9].sum
puts point
