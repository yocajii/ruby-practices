#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

SOLID_WIDTH = 7

def fetch_files(targets)
  if targets.empty?
    [data: ARGF.gets('')]
  else
    targets.map do |filename|
      { name: filename, data: File.read(filename) }
    end
  end
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
    lines, words, bytes = %i[lines words bytes].map { |key| results.sum { |result| result[key] } }
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
  results.each do |result|
    lines, words, bytes = %i[lines words bytes].map { |key| result[key].to_s.rjust(width) }
    print "#{lines} "
    print "#{words} #{bytes} " unless lines_only
    puts result[:name]
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
