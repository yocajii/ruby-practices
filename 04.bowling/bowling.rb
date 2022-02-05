#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数を取得
score = ARGV[0]
scores = score.split(',')

shots = scores.flat_map do |shot|
  if shot == 'X'
    [10, 0]
  else
    shot.to_i
  end
end

# 10フレーム目にストライクがあれば余計な0を除去
last_frame = shots[18..23].each_slice(2).to_a.flat_map do |item|
  if item[0] == 10 && (item[1]).zero?
    item[0]
  else
    item
  end
end
# フレーム単位にして結合
frames = shots[0..17].each_slice(2).to_a.concat([last_frame])

point = 0
# 最後のフレーム以外の得点計算
9.times do |i|
  point += frames[i].sum
  # ボーナス得点
  point += if frames[i][0] == 10 # strike
             # 次フレームもストライクの時
             if frames[i + 1][0] == 10
               if i < 8 # 8フレーム目までの時
                 frames[i + 1][0] + frames[i + 2][0]
               else # 9フレーム目の時
                 frames[i + 1][0] + frames[i + 1][1]
               end
               # 次フレームはストライクではないとき
             else
               frames[i + 1][0] + frames[i + 1][1]
             end
           elsif frames[i].sum == 10 # spare
             frames[i + 1][0]
           else
             0
           end
end
# 最後のフレームは単純に加算
point += frames[9].sum
puts point
