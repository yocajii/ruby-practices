#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

SOLID_WIDTH = 7

def fetch_files(targets)
  files = []
  if targets.empty?
    data = ARGF.gets('')
    files.push({ data: data })
  else
    targets.length.times do
      data = ARGF.readline(nil)
      name = ARGF.filename
      files.push({ name: name, data: data })
    end
  end
  files
end

def count(files)
  results = files.map do |file|
    name = file[:name]
    lines = file[:data].count("\n")
    words = file[:data].split(' ').length
    bytes = file[:data].bytesize
    { name: name, lines: lines, words: words, bytes: bytes }
  end
  if results.length > 1
    lines = results.reduce(0) { |total, result| total + result[:lines] }
    words = results.reduce(0) { |total, result| total + result[:words] }
    bytes = results.reduce(0) { |total, result| total + result[:bytes] }
    results.push({ name: 'total', lines: lines, words: words, bytes: bytes })
  end
  results
end

def calc_width(results, lines_only)
  if results.length == 1 && lines_only
    0
  elsif results[0][:name].nil? # 標準入力の場合
    SOLID_WIDTH
  else
    results.map { |v| [v[:lines], v[:words], v[:bytes]] }.flatten.max.to_s.length
  end
end

def show(results, lines_only, width)
  results.each do |v|
    lines = v[:lines].to_s.rjust(width)
    words = v[:words].to_s.rjust(width)
    bytes = v[:bytes].to_s.rjust(width)
    name = v[:name]
    if lines_only
      puts "#{lines} #{name}"
    else
      puts "#{lines} #{words} #{bytes} #{name}"
    end
  end
end

options = {}
opt = OptionParser.new
opt.on('-l') { |v| options[:l] = v }
targets = opt.parse!(ARGV)

files = fetch_files(targets)
results = count(files)
width = calc_width(results, options[:l])
show(results, options[:l], width)
