# frozen_string_literal: true

require 'etc'
require 'date'

class Item
  TYPES = {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo ' => 'p',
    'link' => 'l',
    'socket' => 's',
    'unknown' => '?'
  }.freeze
  MODE_BITS_LENGTH = 12 # File::Stat#modeのうちファイルタイプ+パーミッションを示す文字数
  SP_BITS_RANGE = (0..2).freeze # MODE_BITS_LENGTHのうちスペシャルビットを表す範囲
  RWX_BITS_RANGE = (3..11).freeze # MODE_BITS_LENGTHのうちパーミッションを表す範囲
  MODE_SYMBOLS = [%w[- r], %w[- w]].freeze
  EXE_MODE_SYMBOLS = { owner: %w[- x S s], other: %w[- x T t] }.freeze

  attr_reader :path

  def initialize(path)
    @path = path
    @lstat = File.lstat(path)
  end

  def name
    File.basename(@path)
  end

  def blocks
    @lstat.blocks / 2
  end

  def ftype_mode
    ftype = @lstat.ftype
    mode_bits = @lstat.mode.to_s(2).match(/.{#{MODE_BITS_LENGTH}}$/).to_s
    TYPES[ftype] + parse_mode(mode_bits)
  end

  def nlink
    @lstat.nlink
  end

  def user
    Etc.getpwuid(@lstat.uid).name
  end

  def group
    Etc.getgrgid(@lstat.gid).name
  end

  def size
    @lstat.size
  end

  def mtime
    @lstat.mtime
  end

  def digit_size
    name.each_char.map { |c| c.bytesize == 1 ? 1 : 2 }.inject(:+)
  end

  private

  def parse_mode(mode_bits)
    mode_bits_array = mode_bits.chars.map(&:to_i)
    special_bits = mode_bits_array[SP_BITS_RANGE]
    rwx_bits = mode_bits_array[RWX_BITS_RANGE].each_slice(3)
    read_write_bits = rwx_bits.map { |v| v[0..1] }
    execute_bits = rwx_bits.map(&:last)
    read_write_symbols = read_write_bits.map do |bits|
      bits.map.with_index { |b, i| MODE_SYMBOLS[i][b.to_i] }.join
    end
    execute_symbols = parse_execute_mode(special_bits, execute_bits)
    [read_write_symbols, execute_symbols].transpose.join
  end

  def parse_execute_mode(special_bits, execute_bits)
    symbols = [EXE_MODE_SYMBOLS[:owner], EXE_MODE_SYMBOLS[:owner], EXE_MODE_SYMBOLS[:other]]
    shifted_special_digits = special_bits.map { |b| b << 1 }
    merged_digits = [execute_bits, shifted_special_digits].transpose.map { |d| d.inject(:+) }
    merged_digits.map.with_index { |d, i| symbols[i][d] }
  end
end
